Feature: I want to test form.awetest.com using background capability

  Background:
    Given I open a browser
    Then I navigate to "http://form.awetest.com/"


  Scenario:
    Then I enter "Ligang" in text field with "id" "entry_1000000"
    Then I select the value "Ruby" in select list with "id" "entry_1000001"
    Then I click the "radio" with "id" "group_1000003_1"
    Then I click the "checkbox" with "id" "group_1000004_1"
    Then I click the "button" with "name" "commit"
    Then I should see "Your response has been recorded.."
    And I close the browser

  Scenario:
    Then I enter "Qi" in text field with "id" "entry_1000000"
    Then I select the value "Java" in select list with "id" "entry_1000001"
    Then I click the "radio" with "id" "group_1000003_2"
    Then I click the "checkbox" with "id" "group_1000004_1"
    Then I click the "button" with "name" "commit"
    Then I should see "Your response has been recorded.."
    And I close the browser


