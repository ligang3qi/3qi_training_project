def create_wait(wait_time=nil)
  wait_time ||= @wait_time
  error_list = [Selenium::WebDriver::Error::JavascriptError,
                Selenium::WebDriver::Error::UnknownError,
                Selenium::WebDriver::Error::NoSuchElementError,
                RSpec::Expectations::ExpectationNotMetError,
                Selenium::WebDriver::Error::StaleElementReferenceError,
                Selenium::WebDriver::Error::NoSuchDriverError,
                RuntimeError,
                ::Exception,
                Selenium::WebDriver::Error]

  @wait = Selenium::WebDriver::Wait.new timeout: wait_time, ignore: error_list
  $driver.set_wait(0) rescue nil
end

def awetestlib?
  not Awetestlib::Runner.nil?
rescue
  return false
end

And(/^I take a screenshot$/) do
  take_screenshot
end

Before do
  @wait_time = 30
  create_wait
  $driver.start_driver
  @browser = Watir::Browser.new($driver.driver)
  manifest_file = File.join(File.dirname(__FILE__), '..', 'manifest.json')
  @params = JSON.parse(File.open(manifest_file).read)['params'] #Have access to all params in manifest file
  @text_list = Hash.new()
  @error_file = File.join(File.dirname(__FILE__), '..', '..', 'error.txt')
  if $step_no.to_i < 3
    $step_no = 2
  else
    $step_no = $step_no + 2
  end
end

AfterStep() do
  if @params['capture_all_screenshots']
    take_screenshot
  end
  $step_no = $step_no + 1
end

After do |scenario|
  if scenario.failed?
    take_screenshot rescue nil
  else
    $step_no = $step_no - 1
  end
  @browser.close rescue nil
  @browser.quit rescue nil
  $driver.driver_quit rescue nil
end

def take_screenshot
  unless $driver.nil? && @browser.nil?
    abc = File.expand_path("../..",File.dirname(__FILE__))
    file_na = abc.split("/").last
    file_path = File.join(File.dirname(__FILE__), '..', '..', "#{file_na.to_s}_#{$step_no}.jpg")
    android_emulator = (@params['device_type'].downcase =~ /^android( ([^"]*) )?emulator$/) rescue false
    unless android_emulator
      # unless @browser.nil?
      #   @browser.screenshot.save(file_path)
      # end
    else
      current_context = $driver.current_context
      Watir::Wait.until {$driver.set_context $driver.available_contexts.first
      $driver.current_context == $driver.available_contexts.first}
      $driver.screenshot(file_path)
      if current_context.downcase.include? 'web'
        step "I switch to the web view"
      else
        $driver.set_context current_context
      end
    end
  end
end
Then(/^I switch to the web view$/) do
  @wait.until {
    $driver.set_context $driver.available_contexts.last
    require 'watir-webdriver'
    @browser = Watir::Browser.new($driver.driver)
    @browser.url
    $driver.current_context == $driver.available_contexts.last
  }
end
