Feature: I want to test a web-based CRM application.

  Background:
    Then I open a chrome browser
    Then I clear cookies
    And I read the data from the "fat_free_crm.xlsx"
    When I navigate to the environment url


  Scenario: Here we cancel creating a new Account and fail the test
    Given I enter text for "admin_u"
    And I enter text for "admin_p"
    Then I fire_event_onclick on "Login"

    And I should see "My Tasks"
    Then I click on "Tasks"
    Then I click the link with href "/accounts"
    And I should see "Accounts"
    And I should not see "Test_account"
    Then I click on "Create Account"

    And I enter text for "Test_account"
    Then I click the link with href "/accounts/new?cancel=true"

    And I should see "Accounts"
    Then I reload the page
    And I should see "Test_account"
    And I close the browser


  Scenario: Here we search and click an existing account
    Given I enter text for "admin_u"
    And I enter text for "admin_p"
    Then I fire_event_onclick on "Login"

    And I should see "My Tasks"
    Then I click on "Tasks"
    Then I click the link with href "/accounts"

    And I should see "Accounts"
    Then I send_keys "palak_1" in query
    And I should see "palak_1"
    Then I click on "accounts_query_result"
    Then I click the link with href "/accounts"
    And I should see "Accounts"
    Then I send_keys "palak_123456789" in query
    And I should see "palak_123456789"
    Then I click on "accounts_query_result_random"
    And I close the browser


