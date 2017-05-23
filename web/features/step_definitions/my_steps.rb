Given(/^I open a browser$/) do
  require 'watir-webdriver'
  @browser = Watir::Browser.new :chrome
  # Selenium::WebDriver::Firefox::Binary.path = "C:\\Program Files\\Mozilla Firefox\\firefox.exe"
  # @browser = Watir::Browser.new :firefox
end

Given(/^I open chrome$/) do
  require 'watir-webdriver'
  @browser = Watir::Browser.new :chrome
end

Given(/^I open firefox$/) do
  require 'watir-webdriver'
  Selenium::WebDriver::Firefox::Binary.path = "C:\\Program Files\\Mozilla Firefox\\firefox.exe"
  @browser = Watir::Browser.new :firefox
end

Given(/^I open latest firefox$/) do
  require 'watir-webdriver'
  # need to install selenium-webdriver v3.4 or later
  # Both firefox.exe and geckodriver.exe should be found in environment path
  @browser = Watir::Browser.new(:firefox, marionette: true)
end

Given(/^I navigate to "(.*?)"$/) do |arg1|
  @browser.goto arg1
end

Then(/^I set "(.*?)" in text_box with id "(.*?)"$/) do |arg1, arg2|
  @browser.text_field(:id, arg2).set arg1
end

Then(/^I set "(.*?)" in text_box with name "(.*?)"$/) do |arg1, arg2|
  @browser.text_field(:name, arg2).set arg1
end

Then(/^I select "(.*?)" in list with id "(.*?)"$/) do |arg1, arg2|
  @browser.select_list(:id, arg2).select arg1
end

Then(/^I select "(.*?)" in radiobutton$/) do |arg1|
  @browser.radio(:value, arg1).set
end

Then(/^I check "(.*?)" in checkbox$/) do |arg1|
  @browser.checkbox(:value, arg1).set
end

Then(/^I click submit$/) do
  @browser.element(:id, 'ss-submit').click
end

Then /^I should see "([^"]*)"$/ do |text|
  # step "I wait 1 second"
  sleep 1

  unless @browser.text.include? text
    fail("Did not find text #{text}")
  end
end

And /^I close the browser$/ do
  @browser.close
end

And /^I enter "([^"]*)" in text field with "?(.*?)"? "([^"]*)"$/ do |value, how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  @browser.text_field(how.to_sym, /#{what}/).set(value)
end

And /^I select the value "([^"]*)" in select list with "?(.*?)"? "([^"]*)"$/ do |value, how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  @browser.select_list(how.to_sym, /#{what}/).select(value)
end

And /^I select the value "([^"]*)" in radio with "?(.*?)"? "([^"]*)"$/ do |value, how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  # puts(value)
  # puts(how)
  # puts(what)
  # @browser.radio(:value, value).set
  @browser.element(how.to_sym, /#{what}/).radio(:value, value).set
end

And /^I select the value "([^"]*)" in checkbox with "?(.*?)"? "([^"]*)"$/ do |value, how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index|text/i or what.is_a?(Regexp)
  # puts(value)
  # puts(how)
  # puts(what)
  # @browser.checkbox(:value, value).set
  @browser.element(how.to_sym, /#{what}/).checkbox(:value, value).set
end



Then /^I click the "?(.*?)"? with "([^"]*)" "([^"]*)"$/ do |element, how, what|
  what = Regexp.new(Regexp.escape(what)) unless how =~ /index/i or what.is_a?(Regexp)
  case element
    when 'link'
      target = @browser.link(how.to_sym, what).when_present.to_subtype
    when 'button'
      target = @browser.button(how.to_sym, what).when_present.to_subtype
    else
      target = @browser.element(how.to_sym, what).when_present.to_subtype
  end
  if target.respond_to?("click")
    # target.fire_event('onclick')
    target.click
  else
    fail("#{element} with #{how} '#{what}' does not respond to 'click'")
  end
  sleep(0.1)
end

When /^I wait (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end






