Feature: I want use Scenario Outline to test form.awetest.com

  Scenario Outline:
    Given I open a browser
    Then I navigate to "http://form.awetest.com/"

    Then I enter "<name>" in text field with "id" "entry_1000000"
    Then I select the value "<svalue>" in select list with "id" "entry_1000001"
    Then I click the "radio" with "id" "group_1000003_1"
    Then I click the "checkbox" with "id" "group_1000004_1"
    Then I click the "button" with "name" "commit"

    Then I should see "Your response has been recorded.."
    Then I select the value "<svalue1>" in select list with "id" "cucumber_form_cukeUser"
    Then I click the "checkbox" with "id" "cucumber_form_cukeType"
    Then I click the "radio" with "id" "cucumber_form_autoChoice_cucumber"
    Then I click the "button" with "name" "commit"

    Then I should see "Thank You.."
    And I close the browser




    Examples:
      | name   | svalue | svalue1    |
      | Ligang | Ruby   | JavaScript |
      | Qi     | Java   | Gherkin    |








