Feature: I want to test a web-based CRM application.

  Background:
    Then I open a chrome browser
    Then I clear cookies
    And I read the data from the "fat_free_crm.xlsx"
    When I navigate to the environment url


  Scenario: Here we create a new Account and delete it..
    Given I enter text for "admin_u"
    And I enter text for "admin_p"
#    Then I click on "Login"
    Then I fire_event_onclick on "Login"

    And I should see "My Tasks"
    Then I click on "Tasks"
#    Then I click on "Accounts"
    Then I click the link with href "/accounts"
    And I should see "Accounts"
    And I should not see "Test_account"
    Then I click on "Create Account"
#    Then I click the "span" with "id" "create_account_arrow"

    And I enter text for "Test_account"
    And I select "customer" from list
    And I select "Rating" from list
#    Then I click on "Create Account Button"
    Then I fire_event_onclick on "Create Account Button"
#    And I click on "Test_account_link"

    And I fire_event_onclick on "Test_account_link"
    And I click on "Delete"
    And I click on "Yes"
    And I should see "Accounts"
    Then I reload the page
    And I should not see "Test_account"
    And I close the browser

  Scenario: Here we create a new Account with no name and expect to see the error message
    Given I enter text for "admin_u"
    And I enter text for "admin_p"
    Then I fire_event_onclick on "Login"

    And I should see "My Tasks"
    Then I click on "Tasks"
    Then I click the link with href "/accounts"
    And I should see "Accounts"
    And I should not see "Test_account"
    Then I click on "Create Account"
    Then I fire_event_onclick on "Create Account Button"
    And I should see "Please specify account name"
    And I close the browser

