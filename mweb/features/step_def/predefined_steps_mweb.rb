def awetestlib?
  not Awetestlib::Runner.nil?
rescue
  return false
end

def navigate_to_environment_url
  if @params and @params['environment'] and @params['environment']['url']
    url = @params['environment']['url']
  elsif @login and @login['url']
    url = @login['url']
  elsif @role and @login[@role] and @login[@role]['url']
    url = @login[@role]['url']
  end
  @browser.goto url
end

When /^I open a browser$/i do
end
When /^I open a new browser$/i do
end
Given /^I open a F?f?irefox B?b?rowser$/i do
end
Given /^I open Firefox$/ do
end
Given /^I open a C?c?hrome B?b?rowser$/i do
end
Given /^I open Chrome$/ do
end
When /^I open an IE B?b?rowser$/i do
end
Given /^I open an I?i?nternet E?e?xplorer B?b?rowser$/i do
end
Given /^I open Internet Explorer$/i do
end
And /^I close the browser$/ do
end

#current
Given /^I connect to the address "([^"]*)"$/ do |arg1|
end

Given /^I connect to the address$/ do
end

Then /^I navigate to the environment url$/ do
  url = @params['environment']['url']
  @browser.goto url
end

Then /^I go to the url "([^"]*)"$/ do |url|
  @browser.goto url
end

Then /^I click "([^"]*)"$/ do |element_text|
  sleep 1
  @browser.element(:text, element_text).click
end

Then /^I click the button "([^"]*)"$/ do |element_text|
  sleep 1
  @browser.button(:text, element_text).click
end

Then /^I click the element with "([^"]*)" "([^"]*)"$/ do |arg1, arg2|
  @browser.element(arg1.to_sym, arg2)
end

Then /^I should see "([^"]*)"$/ do |text|
  stm = false
  begin
    @wait.until { stm = @browser.text.include? text
    stm }
  rescue => e
  end
  fail("Did not find text #{text} \n #{e.message}") unless stm
  stm
end

Then /^I should not see "([^"]*)"$/ do |text|
  stm = false
  begin
    @wait.until { stm = !@browser.text.include?(text)
    stm }
  rescue => e
  end
  fail("Found text #{text}\n #{e.message}") unless stm
  stm
end

Then /^I fill in "([^"]*)" with "([^"]*)"$/ do |field, value| #assumes u have label
  associated_label = @browser.label(:text, field).attribute_value("for")
  #associated_label = @browser.element(:xpath, '//label[contains(text(),"#{arg1}")]').attribute_value("for"))
  @browser.text_field(:id, associated_label).set value
end

Then /^let me debug$/ do
  require 'pry'
  binding.pry
end

When /^I wait (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end

When(/^I should see "([^"]*)" but proceed if not present$/) do |arg|
  @text_list[arg]= @browser.link(:text, "#{arg}").exists?
  File.open(@error_file, "w") do |f|
    f.write(@text_list.to_json)
  end
end

Then /^I go to the (URL|url)$/ do |dummy|
  navigate_to_environment_url
end

Then /^I click the "?(.*?)"? with "([^"]*)" "([^"]*)"$/ do |element, how, what|
  step "I wait until #{element} with #{how} \"#{what}\" is ready"
  #what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  case element
    when 'link'
      target = @browser.link(how.to_sym, what)
    when 'button'
      target = @browser.button(how.to_sym, what)
    else
      target = @browser.element(how.to_sym, what)
  end
  if target.respond_to?("click")
    target.click
  else
    fail("#{element} with #{how} '#{what}' does not respond to 'click'")
  end
end

And /^I enter "([^"]*)" in text field with "?(.*?)"? "([^"]*)"$/ do |value, how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  #step "I wait until text field with #{how} \"#{what}\" is ready"
  @browser.text_field(how.to_sym, /#{what}/).set(value)
end

And /^I enter the value for "([^"]*)" in text field with "?(.*?)"? "([^"]*)"$/ do |index, how, what|
  if index =~ /zipcode/
    value = @var[index].to_i.to_s
  else
    value = index
  end
  step "I enter \"#{value}\" in text field with #{how} \"#{what}\""
end

And /^I select the value "([^"]*)" in select list with "?(.*?)"? "([^"]*)"$/ do |value, how, what|
  #what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  @browser.select_list(how.to_sym, what).select_value(/#{value}/)
end

And /^I select the option "([^"]*)" in select list with "?(.*?)"? "([^"]*)"$/ do |option, how, what|
  #what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  @browser.select_list(how.to_sym, what).select(/#{option}/)
end

And /^I select the value for "([^"]*)" in select list with "?(.*?)"? "([^"]*)"$/ do |index, how, what|
  value = @var[index]
  step "I select the value \"#{value}\" in select list with #{how} \"#{what}\""
end

Then /^I check that the "?(.*?)"? with "?(.*?)"? "([^"]*)" contains "([^"]*)"$/ do |element, how, what, target|
  #what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  step "I wait until #{element} with #{how} \"#{what}\" is ready"
  unless @browser.element(how.to_sym, what).text.include?(target)
    fail ("#{element} with #{how} '#{what}' does not contain '#{target}'")
  end

end

Then /^I check that the text field with "?(.*?)"? "([^"]*)" contains the value for "([^"]*)"$/ do |how, what, index|
  if index =~ /zipcode/
    value = @var[index].to_i.to_s
  else
    value = @var[index]
  end
  #what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  unless @browser.text_field(how.to_sym, what).value.include?(value)
    fail("The text field with #{how} '#{what}' does not contain the value for '${index}' ('#{value}'")
  end
end


When /^I wait until "?(.*?)"? with "?(.*?)"? "([^"]*)" is ready$/ do |element, how, what|
  #what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  ok = false
  if $watir_script
    if @wait.until { @browser.element(how, what).exists? }
      if @wait.until { @browser.element(how, what).visible? }
        if @wait.until { @browser.element(how, what).enabled? }
          ok = true
        end
      end
    end
  else
    case element
      when 'button'
        if @browser.button(how.to_sym, what).wait_until_present
          ok = true
        end
      when 'text field'
        sleep 2
        #if @browser.text_field(how.to_sym, what).wait_until_present
        ok = true
      #end
      else
        if @browser.element(how.to_sym, what).wait_until_present
          ok = true
        end
    end
  end
  unless ok
    fail("#{element} with #{how} '#{what}' is not ready")
  end
end

And /^I click "([^"]*)" in the browser alert$/ do |button|
  if $watir_script
    $ai.WinWait("Message from webpage")
    sleep(1)
    $ai.ControlClick("Message from webpage", "", button)
  else
    @browser.alert.wait_until_present
    case button
      when /ok/i, /yes/i, /submit/i, /Allow/i
        @browser.alert.ok
      when /cancel/i, /close/i
        @browser.alert.close
      else
        fail("'#{button} for alert not recognized.")
    end
  end
end

Then(/^I interact with window having title "([^"]*)"$/) do |arg1| # title of child window
  sleep 5
  counter = 0
  if arg1 == "Parent_Window_Title"
    @browser.driver.switch_to.window(@browser.driver.window_handles[0])
  else
    @browser.windows.each do |win|
      if win.title == arg1 # switches control to child window
        @browser.driver.switch_to.window(@browser.driver.window_handles[counter])
      else
        counter = counter + 1
      end
    end
  end
end

Given /^I load data spreadsheet "([^"]*)" for "([^"]*)"$/ do |file, feature|
  require 'roo'
  @workbook = Excel.new(file)
  @feature_name = feature #File.basename(feature, ".feature")
  step "I load @login from spreadsheet"
  step "I load @var from spreadsheet"
end

Then /^I load @login from spreadsheet$/ do
  @login = Hash.new
  @workbook.default_sheet = @workbook.sheets[0]

  script_col = 0
  role_col = 0
  userid_col = 0
  password_col = 0
  url_col = 0
  name_col = 0

  1.upto(@workbook.last_column) do |col|
    header = @workbook.cell(1, col)
    case header
      when @feature_name
        script_col = col
      when 'role'
        role_col = col
      when 'userid'
        userid_col = col
      when 'password'
        password_col = col
      when 'url'
        url_col = col
      when 'name'
        name_col = col
    end
  end

  2.upto(@workbook.last_row) do |line|
    role = @workbook.cell(line, role_col)
    userid = @workbook.cell(line, userid_col)
    password = @workbook.cell(line, password_col)
    url = @workbook.cell(line, url_col)
    username = @workbook.cell(line, name_col)
    enabled = @workbook.cell(line, script_col).to_s

    if enabled == 'Y'
      @login['role'] = role
      @login['userid'] = userid
      @login['password'] = password
      @login['url'] = url
      @login['name'] = username
      @login['enabled'] = enabled
      break
    end
  end
end

Then /^I load @var from spreadsheet$/ do
  @var = Hash.new
  @workbook.default_sheet = @workbook.sheets[1]
  script_col = 0
  name_col = 0

  1.upto(@workbook.last_column) do |col|
    header = @workbook.cell(1, col)
    case header
      when @feature_name
        script_col = col
      when 'Variable'
        name_col = col
    end
  end

  2.upto(@workbook.last_row) do |line|
    name = @workbook.cell(line, name_col)
    value = @workbook.cell(line, script_col).to_s.strip
    @var[name] = value
  end
end

#may not work on android
Then /^I rotate to landscape$/ do

  begin
    @browser.driver.rotate :landscape
  rescue
    warn("Rotation is not available")
  end
end


#may not work on android
Then /^I rotate to portrait$/ do
  begin
    @browser.driver.rotate :portrait
  rescue
    warn("Rotation is not available")
  end
end







