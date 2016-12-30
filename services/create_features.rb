require 'rubygems'
require 'active_support/all'
require 'roo'
require 'spreadsheet'
require 'pry'
  
puts "The following feature files were created based on the excel sheets - /features/step_definitions/*.xlsx: \n "
new_folder_name = "new_files"
Dir.mkdir(new_folder_name) unless File.exists?(new_folder_name)

# Usage Please pass the excel file name as an argument or specify it in 
# else part of the following condition.
# -c flag to copy feature files directly to features folder
# ex: ruby create_features.rb -c
# specify the file name as well:
# ex: ruby create_features.rb -c features/step_definitions/campaign_regression.xlsx
# just the file name
# ex: ruby create_features.rb features/step_definitions/campaign_regression.xlsx

file_names = Dir["./features/step_definitions/*.xlsx"]
final_folder = "./new_files/"
if ARGV.length > 0
  if ARGV[0] == "-c"
		final_folder = "./features/"
		if  ARGV[1]
			file_name = ARGV[1]
		end
  else
		file_name = ARGV[0]
  end
  if file_name
		@myRoot = File.join(File.dirname(__FILE__),'/')
		file_names = ["#{@myRoot}/#{file_name}"]
  end
end
file_names.select! do |file|
	file.split("/").last[0..1] != '~$'
end
file_names.each do |file_name|
	book = Roo::Spreadsheet.open(file_name)


	book.sheets.each do |e|
		file_name = file_name.split("/").last
		puts e + ".feature"
		user_data = book.sheet(e)
		file = File.new("#{final_folder}#{e}.feature", "w")
		@header_columns = user_data.row(1)[0..user_data.last_column]
		@header_columns.map!{ |el| el.downcase rescue nil}

		# write_feature_scenario(file, e)
		file.write("Feature: This feature file tests all the scenarios from #{e} tab on #{file_name}"+"\n\n")
		# binding.pry
		file.write("  Background:
    Given I have a validate service URL to make \"POST\" request
    And   I read the data from the \"#{file_name}\" and \"#{e}\" tab"+"\n")
		
		# @user_data_row = {}
		for i in 2..user_data.last_row
			# puts user_data.row(i)[@header_columns.index("request type")] POST
			# @user_data_row[user_data.row(i)[0]] = user_data.row(i)[1..user_data.last_column]
			# binding.pry	
			unless user_data.row(i)[0].nil?
				request_type = nil
				request_type_column_present = (user_data.row(i)[@header_columns.index("request type") || @header_columns.index("method/verb")] && user_data.row(i)[@header_columns.index("request type") || @header_columns.index("method/verb")].length > 0) rescue false
				
				if request_type_column_present
					request_type = "\"#{user_data.row(i)[@header_columns.index("request type") || @header_columns.index("method/verb")]}\""
				end
				scenario = user_data.row(i)[@header_columns.index("scenario")]
        tags = user_data.row(i)[@header_columns.index("test id")].to_s rescue nil
        tags = "@" + tags if tags && tags.length > 0
				element_name = user_data.row(i)[@header_columns.index("variable")|| @header_columns.index("element")] rescue ''
				file.write("\n  #{tags}") if tags
        file.write("\n  Scenario: #{scenario}, Element = #{element_name}, Scenario ID = #{user_data.row(i)[0]}, API Name = #{user_data.row(i)[@header_columns.index("api name") || @header_columns.index("end point")]},
    When  I pass variables from row \"#{user_data.row(i)[0]}\"
    And   I make the #{request_type} REST-service call
    Then  I should see response from row \"#{user_data.row(i)[0]}\"\n")
				end
		end
		file.close
		# binding.pry
  end
puts "\nNow you can run your feature file by the command: 'cucumber <your_file_name>.feature'."  
end


