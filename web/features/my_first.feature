Feature: We want to get started with automation and test automation commands

  Scenario: Here we define what we want this in scenario...

#    Given I open a browser
#    Given I open chrome
#    Given I open firefox
    Given I open latest firefox
    And I navigate to "http://bit.ly/watir-webdriver-demo"

    Then I set "Ligang" in text_box with id "entry_1000000"
    Then I select "Ruby" in list with id "entry_1000001"
    Then I select "Both" in radiobutton
    Then I check "1.9.2" in checkbox
    Then I click submit
    Then I should see "Thank you for playing with Watir-WebDriver"

    And I close the browser
