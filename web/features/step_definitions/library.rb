Given(/^I enter text for "(.*?)"$/) do |arg1|
  req_user_data = @user_data_by_r_c[arg1]
  req_obj_repo = @obj_repo_row[req_user_data['obj_repo_id']]
  text_to_enter = req_user_data['Input Value 1']
  step "I enter \"#{text_to_enter}\" in text field with \"#{req_obj_repo[1]}\" \"#{req_obj_repo[2]}\""
end

Then(/^I click on "(.*?)"$/) do |arg1|
  req_user_data = @user_data_by_r_c[arg1]
  req_obj_repo = @obj_repo_row[req_user_data['obj_repo_id']]
  step "I click the \"#{req_obj_repo[0]}\" with \"#{req_obj_repo[1]}\" \"#{req_obj_repo[2]}\""
end

Then(/^I select "(.*?)" from list$/) do |arg1|
  req_user_data = @user_data_by_r_c[arg1]
  req_obj_repo = @obj_repo_row[req_user_data['obj_repo_id']]
  item_to_select = req_user_data['Input Value 1']
  step "I select the value \"#{item_to_select}\" in select list with \"#{req_obj_repo[1]}\" \"#{req_obj_repo[2]}\""
end

Then(/^I select "(.*?)" from radio$/) do |arg1|
  req_user_data = @user_data_by_r_c[arg1]
  req_obj_repo = @obj_repo_row[req_user_data['obj_repo_id']]
  item_to_select = req_user_data['Input Value 1']
  step "I select the value \"#{item_to_select}\" in radio with \"#{req_obj_repo[1]}\" \"#{req_obj_repo[2]}\""
end

Then(/^I select "(.*?)" from checkbox$/) do |arg1|
  req_user_data = @user_data_by_r_c[arg1]
  req_obj_repo = @obj_repo_row[req_user_data['obj_repo_id']]
  item_to_select = req_user_data['Input Value 1']
  step "I select the value \"#{item_to_select}\" in checkbox with \"#{req_obj_repo[1]}\" \"#{req_obj_repo[2]}\""
end

Then /^I delete the task with "(.*?)" "(.*?)"$/ do |how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  #step "I wait until text field with #{how} \"#{what}\" is ready"
  new_task_label = @browser.label(how.to_sym, /#{what}/).when_present.flash
  new_task_label_div = new_task_label.parent.when_present.flash
  new_task_label_div_li = new_task_label_div.parent.when_present.flash
  new_task_label_div_li.hover
  new_task_delete = new_task_label_div_li.div(class: 'tools').element(text: 'Delete!').when_present.flash
  new_task_delete.click
end

Then(/^I reload the page$/) do
  @browser.refresh
  sleep(3)
end

Then(/^I press enter$/) do
  @browser.send_keys(:enter)
  sleep(1)
end

Then /^I enter "([^"]*)" in Assigned to input box$/ do |value|
  outer_div_id = 'select2-drop'
  outer_div = @browser.div(id: outer_div_id).when_present.flash
  input = outer_div.input.when_present.flash
  input.send_keys(value)
end

Then /^I select "([^"]*)" from country dropdown list$/ do |country|
  selector = @browser.div(id: 'select2-drop-mask').when_present.click
  outer_div_id = 'select2-drop'
  outer_div = @browser.div(id: outer_div_id).when_present.flash
  input = outer_div.input.when_present.flash
  input.send_keys(country)
  @browser.send_keys(:arrow_down)
  @browser.send_keys(:enter)
end

Then /^I debug$/ do
  require 'pry'
  binding.pry

  # @browser.text_field(how.to_sym, /#{what}/).set(value)
  # @browser.text_field(:id, 'query').set('palak_1')
  # puts('*******************************************************8')
  # input = @browser.element(:name, 'query')
  # input.flash
  # input.click
  # input.flash
  # puts('ok')
end



And /^I send_keys "([^"]*)" in query$/ do |value|
  # what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  #step "I wait until text field with #{how} \"#{what}\" is ready"
  # puts(what)
  # puts(how.to_sym)
  # puts(value)
  # @browser.text_field(how.to_sym, /#{what}/).when_present.flash.send_keys(value)
  # @browser.text_field(how.to_sym, /#{what}/).send_keys(value)
  input_box = @browser.text_field(:id, 'query').when_present.flash
  input_box.clear
  input_box.send_keys(value)
end




# Then(/^I click link with "([^"]*)" "([^"]*)"$/) do |arg1, arg2|
#   # my_regex = /#{Regexp.escape("#{arg2}")}:\s*(\d+)/i
#   my_regex = /#{Regexp.escape("#{arg2}")}/
#   @browser.link(arg1.to_sym, my_regex).when_present.flash.click
# end

# After do |scenario|
#   if scenario.failed?
#     # require 'pry'
#     # binding.pry
#   end
# end

# Before do
#   require 'pry'
#   @myRoot = File.join(File.dirname(__FILE__),'/')
#   # $env_params = JSON.parse(File.open("#{@myRoot}env_constants.json").read)['env_params']
# end

And(/^I maximize the browser$/) do
  @browser.driver.manage.window.maximize
end

And /^I enter "(.*?)" in the text field with "?(.*?)"? "(.*?)"$/ do |value, how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  #step "I wait until text field with #{how} \"#{what}\" is ready"
  @browser.text_field(how.to_sym, /#{what}/).when_present.flash.set(value)
end

Given(/^I read the data from the "(.*?)"$/) do |arg1|
  require 'roo'
  require 'spreadsheet'
  @myRoot = File.join(File.dirname(__FILE__), '/')
  book = Roo::Spreadsheet.open("#{@myRoot}/#{arg1}")

  obj_repo = book.sheet("obj_repo")
  @obj_repo_row = {}
  for i in 1..obj_repo.last_row
    @obj_repo_row[obj_repo.row(i)[0]] = obj_repo.row(i)[1...obj_repo.last_column]
  end

  user_data = book.sheet("user_data")
  @user_data_row = {}
  for i in 1..user_data.last_row
    @user_data_row[user_data.row(i)[0]] = user_data.row(i)[1...user_data.last_column]
  end

  # @column_data = {}
  # for i in 1..user_data.last_column
  #   value = user_data.column(i)
  #   @column_data[value[0]] = value[1..value.length]
  # end

  # Test values for columns after parsing..
  # @column_data["Scenario ID"]
  # @column_data["Request"]
  # @column_data["Response"]

  @user_data_by_r_c = {}
  # Write this loop to generate "row value"=> ["COLUMN_ID", "Cell Value"]
  # To get the values use @user_data_by_r_c["ROW_ID"]["COLUMN_ID"]
  for i in 1..user_data.last_row
    ud = {}
    # Take the values from the first row starting from second column
    column_vars = user_data.row(1)
    # Loop through the array column_var and create hash for each row item ["COLUMN_ID", "Cell Value"]
    for e in 1...column_vars.length
      # e = 1, 2
      ud[column_vars[e]] = user_data.row(i)[e]
    end
    # Put the newly created hash into @user_data_by_r_c
    @user_data_by_r_c[user_data.row(i)[0]] = ud
  end
  # @user_data_by_r_c["ping"]["Response"]
  # @user_data_by_r_c["ping"]["Result"]
end
