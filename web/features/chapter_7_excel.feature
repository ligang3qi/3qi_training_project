Feature: I want to use excel to get data into our form

  Background:
    Given I open a browser
    Then I navigate to "http://form.awetest.com/"
    And I read the data from the "demo.xlsx"

  Scenario:
    Then I enter text for "Name"
    And I select "Language" from list
    And I select "What is ruby" from radio
    And I select "What versions of ruby" from checkbox
    And I click on "NEXT"

#    Then I wait 5 seconds

    Then I should see "Your response has been recorded.."
    And I close the browser


