#Available validations rules

#	ANYTHING  						will pass if value is anything other than null or completely missing
# INTEGER_POSITIVE 			must be a type of integer
# STRING_NUMERIC        must be a string and must be numeric positive/negative
# STRING_NUMERIC_POSITIVE must be a String, Numeric only and positive


#Updated: Function will ignore the order of elements in the arrays.
#meaning [1,2,3] and [3,1,2]  will be considered as not different
def different?(a, b, bi_directional=true)
  return [a.class.name, nil] if !a.nil? && b.nil?
  return [nil, b.class.name] if !b.nil? && a.nil?

  differences = {}
  a.each do |k, v|
    if special_value(v)
      differences[k] = [v, b[k]] unless validate_special_value(v, b[k])
    else
      if !v.nil? && b[k].nil?
        differences[k] = [v, nil]
        next
      elsif !b[k].nil? && v.nil?
        differences[k] = [nil, b[k]]
        next
      end

      if v.is_a?(Hash)
        unless b[k].is_a?(Hash)
          differences[k] = "Different types"
          next
        end
        diff = different?(a[k], b[k])
        differences[k] = diff if !diff.nil? && diff.count > 0

      elsif v.is_a?(Array)
        unless b[k].is_a?(Array)
          differences[k] = "Different types"
          next
        end

        c = -1
        diff = v.map do |n|
          c += 1
          if n.is_a?(Hash)
            diffs = nil
            if !b[k][c].is_a?(Hash)
              diffs = ["Different types"]
            else
              b[k].map do |val_2|
                if val_2.is_a?(Hash)
                  diffs = different?(n, val_2)
                else
                  diffs = ["Different types"]
                end
                break if diffs.nil?
              end
              diffs = different?(n, b[k][c]) if diffs && b[k][c].is_a?(Hash)
            end
            ["Differences: ", diffs] if diffs
          elsif n.is_a?(Array)
            if !b[k][c].is_a?(Array)
              diffs = ["Different types"]
            else
              b[k].each do |val_2|
                diffs = check_arrays(n, val_2)
                break unless diffs
              end
            end
            diffs if diffs
          elsif special_value(n)
            [n, b[k][c]] unless validate_special_value n, b[k][c]
          else
            arr_val_found = nil
            b[k].each do |val_2|
              arr_val_found = val_2 == n
              break if arr_val_found
            end
            [n, b[k][c]] unless arr_val_found
          end
        end.compact
        differences[k] = diff if diff.count > 0
      else
        differences[k] = [v, b[k]] unless v == b[k]
      end
    end
  end
  return differences if !differences.nil? && differences.count > 0
end

def check_arrays(arr1, arr2)
  diff = nil
  if arr2.is_a?(Array)
    c = -1
    diff = arr1.map do |n|
      c += 1
      if n.is_a?(Hash)
        diffs = nil
        if !arr2[c].is_a?(Hash)
          diffs = ["Different types"]
        else
          arr2.each do |val_2|
            if val_2.is_a?(Hash)
              diffs = different?(n, val_2)
            else
              diffs = ["Different types"]
            end
            break if diffs.nil?
          end
          diffs = different?(n, arr2[c]) if diffs && arr2[c].is_a?(Hash)
        end
        ["Differences: ", diffs] if diffs
      elsif n.is_a?(Array)
        diffs = nil
        if !arr2[c].is_a?(Array)
          diffs = "Different types"
        else
          arr2.each do |nested_array|
            if nested_array.is_a?(Array)
              diffs = check_arrays(n, nested_array)
              break unless diffs
            else
              diffs = "different types"
            end
          end
        end
        [n, arr2[c]] if diffs
      elsif special_value(n)
        [n, arr2[c]] unless validate_special_value n, arr2[c]
      else
        arr_val_found = nil
        arr2.each do |val_2|
          arr_val_found = val_2 == n
          break if arr_val_found
        end
        [n, arr2[c]] unless arr_val_found
      end
    end.compact
  else
    diff = ["Different types"]
  end
  diff if diff && diff.count > 0
end

def special_value(v)
  result = false
  if v && v.is_a?(String)
    case v
      when "ANYTHING", "NOTHING", "STRING", "INTEGER", "INTEGER_POSITIVE", "STRING_NUMERIC", "STRING_NUMERIC_POSITIVE", "CURRENT_UTC", "DATE_TIME", "DATE_TIME_OR_NULL", "STRING_OR_NULL", "DT_FULL_YEAR_TIME_ZONE", "DATE_TIME_Y_l", "DATE_TIME_Y"
        result=true
    end
  end
  result
end

def validate_special_value(v, v2)
  result = false
  case v
    when "ANYTHING"
      result = !v2.nil?
    when "NOTHING"
      result = v2.nil?
    when "STRING"
      result =v2 && v2.is_a?(String)
    when "STRING_OR_NULL"
      result =v2.nil? || (v2 && v2.is_a?(String))
    when "INTEGER"
      result = v2 && v2.is_a?(Integer)
    when "INTEGER_POSITIVE"
      result = v2 && v2.is_a?(Integer) && v2 > 0
    when "STRING_NUMERIC"
      result =v2 && v2.is_a?(String) && v2 =~ /\A\-?\d+\z/
    when "STRING_NUMERIC_POSITIVE"
      result = v2 && v2.is_a?(String) && v2 =~ /\A\d+\z/ && v2.to_i > 0
    when "CURRENT_UTC"
      result = v2 && (Time.now).getutc.strftime("%m/%d/%y %I:%M %p") == v2 || (Time.now - 59).getutc.strftime("%m/%d/%y %I:%M %p") == v2
      puts "CURRENT_UTC: " + (Time.now).getutc.strftime("%m/%d/%y %I:%M %p")
    when "DATE_TIME"
      check = DateTime.strptime(v2, '%m/%d/%y %I:%M %p').strftime("%m/%d/%y %I:%M %p") rescue false
      result = v2 == check if check
      puts "#{v2} != #{check}" unless result
    when "DATE_TIME_Y_l"
      check = DateTime.strptime(v2, '%m/%d/%Y %l:%M %p').strftime("%m/%d/%Y %-l:%M %p") rescue false
      result = v2 == check if check
      puts "#{v2} != #{check}" unless result
    when "DATE_TIME_Y"
      check = DateTime.strptime(v2, '%m/%d/%Y %I:%M %p').strftime("%m/%d/%Y %I:%M %p") rescue false
      result = v2 == check if check
      puts "#{v2} != #{check}" unless resul
    when "DT_FULL_YEAR_TIME_ZONE"
      check = DateTime.strptime(v2, '%m/%d/%Y %I:%M %p %Z').strftime("%m/%d/%Y %I:%M %p") rescue false
      result = v2[0..-5] == check if check
      puts "#{v2} != #{check}" unless result
    when "DATE_TIME_OR_NULL"
      if v2 == nil
        result = true
      else
        check = DateTime.strptime(v2, '%m/%d/%y %I:%M %p').strftime("%m/%d/%y %I:%M %p") rescue false
        result = v2 == check if check
        puts "#{v2} != #{check}" unless result
      end
  end
  result
end


def clear
  $test_params = {}
  $test_items = []
end

def execute_steps(steps)
  steps = steps.split(', ')
  steps.each { |step|
    puts "*******************"
    puts "#{step}"
    eval("#{step}")
    puts "*********end**********"
  }
end

def replace_url_params
  true
end

#string string to replace params in
#params @headers - specify if the params to replace are header params.
def replace_params(string, hash={"a" => "b"}, prefix='', url=false, headers = false) #(keys)
#will replace all the params in test items hash with they special capital values in the request and header and response
# all keys in the request and response that will be replaced must be in quotes and all caps ex: "TOKENREQUESTORID"
  string = apply_no_key_value string
  $test_params ||= {}
  #check if no initial hash is passed, so that we will use test_items hash as a hash with values that we will replace
  if hash['a'] == 'b'
    hash = $test_params
  end
  #check if we want to use test_items to replace params that we are storing for a specific item
  if prefix !~ /item_/ && hash == $test_params && (string.include?("\"item_"))
    #prefix = 'item_'
    #replace params for each item in the test_items hash
    #ALL items specific keys to be replaced  must have item_#  before the actual value
    $test_items.each_with_index { |item_hash, index|
      string = replace_params string, item_hash, "#{'item_'}#{index+1}_", url, headers
    }
    #prefix = ''
  end

  #Actuall replacing loop, goes through the hash and replaces
  hash.each { |key, value|
    value = value.to_s if headers && (value.is_a?(Integer) || value.is_a?(Float)) #headers will always have strings as values
    if value.nil?
      string = string.gsub("\"#{prefix + key.upcase}\"", 'null')
    elsif value.is_a? String
      string = string.gsub("\"#{prefix + key.upcase}\"", "\"#{value}\"") unless url
      string = string.gsub("\"#{prefix + key.upcase}\"", "#{value}") if url
    elsif value.is_a? Hash #call itself if a hash
      string = replace_params(string, value, prefix, url, headers)
    elsif value.is_a? Array and value[0].is_a? Hash
      value.each { |sub_hash|
        string = replace_params(string, sub_hash, prefix, url, headers)
      }
    elsif value.is_a? Integer or value.is_a? Array or value.is_a? Float
      string = string.gsub("\"#{prefix + key.upcase}\"", "#{value}")
    else
      #warn("Ooops, don't know how to handle value to be replaced, #{value}")
    end
  }
  string
end

#If the value we capture does not has the same type every time. and we capture multiple times, It will store up to 2 values of different type.
# the original key will have the last value and the key_ will have the previously stored value of a different type.
#this is so that we can store and array and an object at the same time when we get different value types of in the result of the object
def capture_test_params(act_par, capture_to_hash = $test_params)
  act_par ||= {}
  act_par.each_key { |key|
    if act_par[key].is_a? Hash
      capture_test_params(act_par[key], capture_to_hash)
    elsif act_par[key].is_a?(Array) && act_par[key][0].is_a?(Hash)
      act_par[key].each { |hash|
        if hash.is_a?(Hash)
          capture_test_params(hash, capture_to_hash)
        end
      }
    elsif act_par[key].is_a?(Array) && act_par[key][0].is_a?(Array)
      act_par[key].each { |array|
        array.each { |hash|
          if hash.is_a?(Hash)
            capture_test_params(hash, capture_to_hash)
          end
        }
      }
    end
    case key.to_s
      when *$capture_params
        capture_to_hash.deep_merge!({key.to_s => act_par[key]}) if act_par[key]
    end }
end


def apply_no_key_value (string)
  if string && string.include?("NO_K_V")
    hash = JSON.parse(string)
    hash = apply_no_key_value_helper(hash)
    string = hash.to_json
  end
  string
end

def apply_no_key_value_helper(hash)
  hash.each_key do |key|
    if hash[key].is_a? String
      hash.delete(key) if hash[key]== "NO_K_V"
    elsif hash[key].is_a? Hash
      apply_no_key_value_helper(hash[key])
    elsif hash[key].is_a? Array
      hash.delete(key) if hash[key][0]== "NO_K_V"
      if hash[key][0].is_a? Hash
        hash[key].each do |sub_hash|
          apply_no_key_value_helper(sub_hash)
        end
      end
    end
  end
end

#The function will merge 2 hashes and if it includes Arrays of objects, it will merge the objects within the array
def deep_merge_custom(hash_1, hash_2)
  hash_1.deep_merge(hash_2) { |key, val_1, val_2|
    if val_1.is_a?(Array) && val_2.is_a?(Array) && val_1[0].is_a?(Hash) && val_2[0].is_a?(Hash)
      new_arr = []
      val_2.each_with_index { |value, index|
        val_1[index] ||= {}
        new_arr[index] = deep_merge_custom(val_1[index], val_2[index])
      }
      new_arr
    else
      val_2
    end
  }
end
