#Use this file to define functions that can be called using setup steps and after steps columns in the excel as well as generate_request function. Also yo can modify generate request function as needed.
#You should only use other service calls in the functions you define.
#
#You can call service with rest_service_call function that returns an array of values [response body, response headers, response code] stab is:
#def rest_service_call(request_type=nil,url=nil,headers=nil,body=nil, proxy=false)
#Example usage:
#def published_campaign
#   req_param ={
#       "key"=> "value"
#   }
#   req_param = req_param.to_json
#   act_par = rest_service_call('post',url,@req_header,req_param)[0]
#   act_par = ActiveSupport::JSON.decode(act_par)
#   $test_params['result'] = act_par['result']  # to capture result if needed
#end

#Generate params for the request. Params should be saved to global $test_params hash and will get automatically replaced in the request/headers/expected response
def generate_request(req_param)
  if req_param.include? '"NEW_FIRSTNAME"'
    result = rand_string_alpha(5)
    $test_params["NEW_FIRSTNAME"] = result
    $test_params["FIRSTNAME"] = $test_params["NEW_FIRSTNAME"]
  end
  if req_param.include? '"NEW_LASTNAME"'
    result = rand_string_alpha(5)
    $test_params["NEW_LASTNAME"] = result
    $test_params["LASTNAME"] = $test_params["NEW_LASTNAME"]
  end
  if req_param.include? '"NEW_PASSWORD"'
    result = rand_string_alpha(8)
    $test_params["NEW_PASSWORD"] = result
    $test_params["PASSWORD"] = $test_params["NEW_PASSWORD"]
  end
  if req_param.include? '"NEW_USERNAME"'
    result = rand_string_alpha(15)
    $test_params["NEW_USERNAME"] = result
    $test_params["OLD_USERNAME"] = $test_params["USERNAME"] || $test_params["NEW_USERNAME"]
    $test_params["USERNAME"] = $test_params["NEW_USERNAME"]
  end
  if req_param.include? '"NEW_NAME"'
    result = rand_string_alpha(10)
    $test_params['NEW_NAME'] = result
    $test_params['OLD_NAME'] = $test_params['NAME'] || $test_params['NEW_NAME']
    $test_params['NAME'] = $test_params['NEW_NAME']
  end

  if req_param.include? '"NEW_EMAIL"'
    result = rand_string_alpha(10)
    $test_params["NEW_EMAIL"] = result + "@example.com"
    $test_params["EMAIL"] = $test_params["NEW_EMAIL"]
  end

  if req_param.include? '"NEW_PHONE"'
    rand_string_numeric(10)
    $test_params["NEW_PHONE"] = "(#{rand_string_numeric(3)})-#{rand_string_numeric(3)}-#{rand_string_numeric(4)}"
    $test_params["PHONE"] = $test_params["NEW_PHONE"]
  end

  if req_param.include? '"SOME_DATE_EXAMPLE"'
    suffix_string = "10:00 AM"
    prefix_string = Time.now.strftime("%m/%d/%y ")
    date_string = prefix_string + suffix_string
    $test_params['SOME_DATE_EXAMPLE'] = date_string
  end


end

#Function generates a random string
#param length of the string
#return random Alpha string
def rand_string_alpha(length, save_as = nil)
  chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ'
  result = Array.new(length) { chars[rand(chars.length)].chr }.join
  $test_params[save_as] = result if save_as
  result
end

def rand_alpha_numeric(length, save_as = nil)
  chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789'
  result = Array.new(length) { chars[rand(chars.length)].chr }.join
  $test_params[save_as] = result if save_as
  result
end

def rand_string_numeric(length, save_as = nil)
  chars = '0123456789'
  result = Array.new(length) { chars[rand(chars.length)].chr }.join
  $test_params[save_as] = result if save_as
  result
end

def copy_param(existing, new)
  $test_params[new] = $test_params[existing]
end

def capture_int(key)
  $test_params[key] = @act_resp.to_i
end