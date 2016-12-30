Before do
  require 'active_support/all'
  require 'roo'
  require 'spreadsheet'
  require 'pry'
  require 'digest'
  require 'rest_client'
  require 'securerandom'
  require 'rubygems'

  @myRoot ||= File.join(File.dirname(__FILE__), '/')
  # @myRoot is project/features/step_definitions/
  $manifest_file ||= File.join(File.dirname(__FILE__), '..', 'manifest.json')
  $env_constants_file ||= JSON.parse(File.open("#{@myRoot}../tc_assets/env_constants.json").read) rescue nil
  $env_constants_file ||= JSON.parse(File.open("#{@myRoot}env_constants.json").read) rescue {}
  $params ||= JSON.parse(File.open($manifest_file).read)['params'] #Have access to all params in manifest file
  @params = $params
  # $params and @params means value of 'params' in project/features/manifest.json
  $env_params ||= $env_constants_file['env_params'][$params['environment']['name']] rescue nil
  $env_params ||= {}
  $env_urls ||= $env_constants_file['env_urls'][$params['environment']['name']] rescue nil
  $env_urls ||= {}
  $capture_params ||= $env_constants_file['capture_params'] rescue []
  # $env_params means env_params['DEV or prod'] in project/features/tc_assets/env_constants.json
  # $env_urls means env_urls['DEV or prod'] in project/features/tc_assets/env_constants.json
end

#returns request and headers given the API and a method if needed
def get_request_detailed(api_to_call, method=nil)
  if method
    api_to_call = "#{api_to_call}_#{method.upcase}"
  end
  url = $sample_requests[api_to_call][$sample_headers.index('url')] rescue nil
  request = $sample_requests[api_to_call][$sample_headers.index('request')]
  headers = $sample_requests[api_to_call][$sample_headers.index('headers') || $sample_headers.index('header params')]
  request_type = $sample_requests["#{api_to_call}"][$sample_headers.index('request type') || $sample_headers.index('method/verb')] rescue nil
  request_type ||= @type
  [request, headers, url, request_type]
end


When(/^I pass variables from row "(.*?)"$/) do |arg1|
  $test_params ||= {}
  $test_items ||= []
  @row_id = arg1
  api_to_call = $user_data_row["#{arg1}"][$header_columns.index('api name') || $header_columns.index('end point')] || ''
  url = $user_data_row["#{arg1}"][$header_columns.index('url')] rescue nil
  @url = $env_urls[url] || url if url
  @url = @url + api_to_call
  replace_url_params
  $test_params
  @scenario = $user_data_row["#{arg1}"][$header_columns.index('scenario')] rescue ''
  @test_element = $user_data_row["#{arg1}"][$header_columns.index('variable')|| $header_columns.index('element')] rescue ''
  @req_param = $user_data_row["#{arg1}"][$header_columns.index('request')]
  @resp_param = $user_data_row["#{arg1}"][$header_columns.index('expected response') || $header_columns.index('response')]
  @empty_response = !@resp_param
  @resp_param ||= ''
  @req_header = $user_data_row["#{arg1}"][$header_columns.index('headers') || $header_columns.index('header params')] rescue nil
  @req_header ||= '{}'
  @exp_header = $user_data_row["#{arg1}"][$header_columns.index('expected headers')] rescue nil
  @exp_header ||= '{}'
  @request_type = $user_data_row["#{arg1}"][$header_columns.index('request type') || $header_columns.index('method/verb')] rescue nil
  smoke_test_id = $user_data_row["#{arg1}"][$header_columns.index('smoke test id')] rescue nil
  request_type = @request_type
  # binding.pry
  @request_type ||= @type
  api_to_call = "#{api_to_call}_#{request_type.upcase}" if request_type
  if $sample_requests[api_to_call] || smoke_test_id
    if smoke_test_id
      sample_header = $sample_requests_by_id["#{smoke_test_id}"][$s_r_header_columns.index('headers') || $s_r_header_columns.index('header params')] rescue nil
    else
      sample_header = $sample_requests[api_to_call][$sample_headers.index('headers') || $sample_headers.index('header params')]
    end
    sample_header ||= '{}'
    @req_header = deep_merge_custom(JSON.parse(sample_header), JSON.parse(@req_header)).to_json

    if @request_type.upcase == 'GET' || @request_type.upcase == 'DELETE'
      true #TODO nothing is in the request will it stay this way
    else #POST etc..
      if smoke_test_id
        sample_request = $sample_requests_by_id["#{smoke_test_id}"][$s_r_header_columns.index('request')] rescue (raise "no such smoke/sample request found for id #{smoke_test_id}")
      else
        sample_request = $sample_requests[api_to_call][$sample_headers.index('request')]
      end
      @req_param ||= '{}'
      @req_param = deep_merge_custom(JSON.parse(sample_request), JSON.parse(@req_param)).to_json
    end
  end

  set_up_step = $user_data_row["#{arg1}"][$header_columns.index('set up steps')] rescue nil
  # generate_request(@req_param)
  # generate_request(@req_header)
  if !set_up_step.nil? && set_up_step.length > 1
    execute_steps(set_up_step)
  end
end

#returns an array of values [response body, response headers, response code, final request, final headers, actual url, response_time]
def rest_service_call(request_type=nil, url=nil, headers=nil, body=nil, proxy=false)
  error = nil
  body= before_request_body(url, body) rescue body
  beginning_time = nil
  end_time = nil

  generate_request(headers) if headers
  generate_request(url) if url
  generate_request(body) if body
  headers = replace_params(headers, $test_params)
  headers = replace_params(headers, $env_params)
  if request_type.upcase == 'GET' || request_type.upcase == 'DELETE'
    url = "#{url}#{body}"
  else
    body = replace_params(body, $test_params) if body
    body = replace_params(body, $env_params) if body
  end
  url = replace_params(url, $test_params, '', true)
  url = replace_params(url, $env_params, '', true)
  headers = JSON.parse(headers)
  request_type = @type if !request_type || request_type.strip.empty?
  if headers['Content-Type'] == 'application/x-www-form-urlencoded'
    body = JSON.parse(body) if body
  end

  url = URI.encode url
  puts '*********************************'
  puts "Request: #{request_type}"
  puts 'URL: ' + url
  puts '************Header***************'
  puts "#{headers}"
  puts '************Request**************' if request_type != 'GET'
  puts "#{body}" if request_type.upcase != 'GET' && request_type.upcase != 'DELETE'
  puts '*********************************'
  RestClient.proxy = @proxy if proxy
  #begin - rescue block for capturing error codes so the script does not stop.
  beginning_time = Time.now
  begin
    case request_type.upcase
      when 'POST'
        JSON.parse(body) rescue fail("request Json could not be parsed, need to fix json request: Make sure special characters are escaped properly\n #{body}") if body
        act_resp = RestClient.post(url, body, headers)
      when 'POST_MULTIPART'
        body = JSON.parse(body)
        body[:multipart] = true
        file = body.select { |key, value| key.to_s.match(/file/) }
        if file && file.keys && file.keys[0] && body[file.keys[0]] && body[file.keys[0]].to_s.length > 0
          upload_file = File.new("#{@myRoot}../tc_assets/#{body[file.keys[0]]}", 'rb') rescue nil
          upload_file ||= File.new("#{@myRoot}#{body[file.keys[0]]}", 'rb') rescue body[file.keys[0]]
          body[file.keys[0]] = upload_file
        end
        act_resp = RestClient.post url, body, headers
      when 'GET'
        act_resp = RestClient.get(url, headers)
      when 'PUT'
        act_resp = RestClient.put(url, body, headers)
      when 'DELETE'
        act_resp = RestClient.delete(url, headers)
      else
        raise(::NotImplementedError, "Unknown request type: #{request_type}")
    end
  rescue RestClient::InternalServerError => e
    act_code = 500
    act_resp = e.response.body rescue ''
  rescue RestClient::Unauthorized => e
    act_code = 401
    act_resp = e.response.body rescue ''
  rescue RestClient::UnprocessableEntity => e
    act_code = 422
    act_resp = e.response.body rescue ''
  rescue ::NotImplementedError => e
    raise(e)
  rescue RestClient::ResourceNotFound => e
    act_code = 404
    act_resp = e.response.body rescue ''
  rescue RestClient::MethodNotAllowed => e
    act_code = 405
    act_resp = e.response.body rescue ''
  rescue RestClient::BadRequest => e
    act_code = 400
    act_resp = e.response.body rescue ''
  rescue => e
    error = "Error: #{e.to_s}\n #{e.backtrace.to_s}"
    act_code = 999
    act_resp = e.response.body rescue 'N/A'
  end
  end_time = Time.now
  RestClient.proxy = "" if proxy
  act_resp_headers = act_resp.headers rescue {}
  act_resp_headers = Hash[act_resp_headers.map { |k, v| [k.to_s, v] }]
  act_code ||= act_resp.code rescue nil
  act_resp = '' if act_resp.nil?
  response_time = (end_time - beginning_time).to_s rescue 'N/A'
  puts '************Response*************'
  puts "Status: #{act_code}"
  puts "Duration: #{response_time} s"
  act_resp = act_resp.to_s.force_encoding('iso-8859-1').encode('utf-8')
  act_resp = JSON.pretty_generate(JSON.parse(act_resp)) rescue act_resp
  puts act_resp
  puts '******Response Headers***********'
  puts act_resp_headers.to_s
  puts '*********************************'
  [act_resp, act_resp_headers, act_code, body, headers, url, response_time, error]
end

When(/^I make the ?"?([^"]*)?"? ?REST-service call$/) do |request_type|
  result = rest_service_call(@request_type, @url, @req_header, @req_param)
  @act_resp = result[0]
  @act_resp_headers = result[1]
  @act_code = result[2]
  @req_param = result[3]
  @req_header = result[4]
  @url = result[5]
  @response_time = result[6]
  @error = result[7]
end

Then(/^I should see response from row "(.*?)"$/) do |arg1|
  @resp_param= resp_check(@url, @resp_param) rescue @resp_param
  @resp_param = replace_params(@resp_param, $test_params)
  @resp_param = replace_params(@resp_param, $env_params)
  @exp_header = replace_params(@exp_header, $test_params, '', false, true)
  @exp_header = replace_params(@exp_header, $env_params, '', false, true)
  exp_headers = ActiveSupport::JSON.decode(@exp_header)
  exp_code = $user_data_row["#{arg1}"][$header_columns.index('code') || $header_columns.index('response code')].to_i rescue nil
  d = @error
  d ||= 'Missing expected response or expected code' if @empty_response && (!exp_code || exp_code == 0)
  @exp_code = exp_code
  act_code = @act_code

  if @resp_param == 'NOTHING'
    d ||= 'Unexpected response' if @act_resp != ''
  elsif !d
    if @resp_param.strip[0] == '[' && @resp_param.strip[-1] == ']'
      resp_par = "{\"arrayResponse\":" + @resp_param + '}'
    else
      resp_par = @resp_param
    end
    resp_par = '{}' if resp_par == ''
    resp_par = ActiveSupport::JSON.decode(resp_par) rescue resp_par


    begin
      if @act_resp.strip[0] == '[' && @act_resp.strip[-1] == ']'
        act_par = "{\"arrayResponse\":" + @act_resp + '}'
      else
        act_par = @act_resp
      end
      act_par = ActiveSupport::JSON.decode(act_par)
    rescue => e
      puts '** WARN: Invalid json in the response'
      puts e.to_s
      puts '************'
    end
    unless @empty_response
      if resp_par.is_a?(Hash) && act_par.is_a?(Hash)
        d = different?(resp_par, act_par)
      else
        d = ["Responses do not match: Different Types: expected: #{resp_par.to_s} actual:#{act_par.to_s}"] if resp_par != act_par
      end
    end
  end

  if !exp_code.nil? && exp_code != 0 && exp_code != ''
    if act_code != exp_code && d.nil?
      d ||= ["Response Code: [#{exp_code}, #{act_code}]"]
    end
  end
  d ||= different?(exp_headers, @act_resp_headers)

  capture = $user_data_row["#{arg1}"][$header_columns.index('capture')] rescue nil
  if !capture.nil? && capture.to_s.downcase =~ /y/
    capture_test_params act_par if act_par.is_a? Hash
    capture_test_params @act_resp_headers
  elsif !capture.nil?
    item_index = capture.to_i - 1
    $test_items ||= []
    $test_items[item_index] ||= {}
    capture_test_params act_par, $test_items[item_index] if act_par.is_a? Hash
  end
  puts '***Current Params****'
  puts $test_params.to_s
  puts '***test items**'
  puts $test_items.to_s
  puts '*********************'


  ###	binding.pry
  begin
    $validation_errors = nil
    if d.nil?
      validation_steps = $user_data_row["#{arg1}"][$header_columns.index('validation steps')] rescue nil
      if !validation_steps.nil? && validation_steps.length > 1
        execute_steps(validation_steps)
      end
    end
  rescue => e
    $validation_errors ||= []
    $validation_errors << e.to_s
  end
  begin
    after_step = $user_data_row["#{arg1}"][$header_columns.index('after steps')]
    if !after_step.nil? && after_step.length > 1
      execute_steps(after_step)
    end
  rescue => e
    puts 'after steps error:'
    puts e.to_s
    puts '-----'
  end


  if d
    @failing_error = "
				Did not receive the expected response.. \n
				Difference is reported in format(Nesting=>[Expected_response, Actual_response]) \n#{d}
    \n\n"
    fail("#{@failing_error}")
  else
    @failing_error = ''
    puts 'Test passed.'
  end
  if $validation_errors && $validation_errors.count > 0
    @failing_error = $validation_errors.to_s
    raise($validation_errors.to_s)
  end
end

#All well beyond this point.. plz dont touch anything..

Given(/^I read the data from the "(.*?)" and "(.*?)" tab$/) do |arg1, arg2|
  if (!$current_excel && !$current_excel_sheet) || (($current_excel && $current_excel !=arg1) || ($current_excel_sheet && $current_excel_sheet !=arg2))
    $current_excel = arg1
    $current_excel_sheet = arg2
    $data_changes_for = arg2
    book = Roo::Spreadsheet.open("#{@myRoot}../tc_assets/#{arg1}") rescue nil
    book ||= Roo::Spreadsheet.open("#{@myRoot}#{arg1}")
    user_data = book.sheet("#{arg2}")
    $user_data_row = {}
    $sample_requests = {}
    $sample_requests_by_id = {}
    for i in 1..user_data.last_row
      $user_data_row[user_data.row(i)[0].to_s] = user_data.row(i)[1..user_data.last_column]
    end
    $header_columns = user_data.row(1)[1..user_data.last_column]
    $header_columns.map! { |el| el.downcase rescue nil }
    book1 = Roo::Spreadsheet.open("#{@myRoot}../tc_assets/Smoke_test.xlsx") rescue nil
    book1 ||= Roo::Spreadsheet.open("#{@myRoot}Smoke_test.xlsx") rescue nil
    sample_requests = book1.sheet('Smoke_test') rescue nil
    unless sample_requests
      sample_requests = book.sheet('sample_requests') rescue nil
      unless sample_requests
        sample_requests = book.sheet('Smoke_test') rescue nil
      end
    end
    #sample request will be found by unique key API NAME_Request Type
    #if there is no request type it will only use API Name
    if sample_requests
      for i in 1..sample_requests.last_row #have sample request by id, considering adding since we may have save requests path for differet actions
        $sample_requests_by_id[sample_requests.row(i)[0].to_s] = sample_requests.row(i)[1..sample_requests.last_column]
      end
      $s_r_header_columns = sample_requests.row(1)[1..sample_requests.last_column]
      $s_r_header_columns.map! { |el| el.downcase rescue nil }
      if arg2 != 'Smoke_test'
        $sample_headers = sample_requests.row(1)[1..sample_requests.last_column]
        $sample_headers.map! { |el| el.downcase rescue nil }
        key_column = $sample_headers.index('api name') || $sample_headers.index('end point')
        request_type_column = $sample_headers.index('request type') || $sample_headers.index('method/verb') rescue nil
        key_column +=1
        request_type_column +=1 if request_type_column
        for i in 2..sample_requests.last_row
          request_type = sample_requests.row(i)[request_type_column] if request_type_column
          api_signature = sample_requests.row(i)[key_column].to_s + (!request_type ? "" : "_#{request_type.upcase}")
          $sample_requests[api_signature] ||= sample_requests.row(i)[1..user_data.last_column]
        end
      end
    end
  end
end

Given(/^I have a validate service URL to make "([^"]*)" request$/) do |arg|
  @url = $params['environment']['url']
  @env = $params['environment']['name']
  @type = arg
end


def get_test_by_id(arg1)
  api_to_call = $sample_requests_by_id["#{arg1}"][$s_r_header_columns.index('api name') || $s_r_header_columns.index('end point')]
  url = $params['environment']['url']
  url_tmp = $sample_requests_by_id["#{arg1}"][$s_r_header_columns.index('url')] rescue nil
  url = $env_urls[url_tmp] || url_tmp if url_tmp
  url = url + api_to_call
  req_header = $sample_requests_by_id["#{arg1}"][$s_r_header_columns.index('headers') || $s_r_header_columns.index('header params')] rescue nil
  req_header ||= '{}'
  req_param = $sample_requests_by_id["#{arg1}"][$s_r_header_columns.index('request')]
  request_type = $sample_requests_by_id["#{arg1}"][$s_r_header_columns.index('request type') || $s_r_header_columns.index('method/verb')] rescue nil
  request_type ||= @type
  exp_response = $sample_requests_by_id["#{arg1}"][$s_r_header_columns.index('expected response') || $s_r_header_columns.index('response')] rescue nil
  code = $sample_requests_by_id["#{arg1}"][$s_r_header_columns.index('code')] rescue nil
  [request_type, url, req_header, req_param, exp_response, code]
end

def call_api_by_id(capture, arg1)
  request = get_test_by_id(arg1)
  request_type = request[0]
  url= request[1]
  req_header=request[2]
  req_param=request[3]
  act_resp = rest_service_call request_type, url, req_header, req_param
  act_par = ActiveSupport::JSON.decode(act_resp[0]) rescue nil
  act_header =act_resp[1]
  if capture
    capture_test_params act_par if act_par
    capture_test_params act_header
  end
end


def call_api_by_path(capture, path, method = nil)
  url = $params['environment']['url']
  request_details = get_request_detailed(path, method)
  url = $env_urls[request_details[2]] || request_details[2] if request_details[2]
  url += path
  req_param = request_details[0]
  req_header = request_details[1]
  request_type = request_details[3]
  act_resp = rest_service_call request_type, url, req_header, req_param
  act_par = ActiveSupport::JSON.decode(act_resp[0]) rescue nil
  act_header =act_resp[1]
  if capture
    capture_test_params act_par if act_par
    capture_test_params act_header
  end
end

