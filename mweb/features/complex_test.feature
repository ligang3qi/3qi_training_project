Feature: I want to test a web-based CRM application.

  Background:
    Then I open a chrome browser
    Then I clear cookies
    And I read the data from the "fat_free_crm.xlsx"
    When I navigate to the environment url


  Scenario: Here we create an account then create a task and a contact under this account and we verify the task and the contact are linked with the account
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
    And I select "customer" from list
    And I select "Rating" from list
    Then I fire_event_onclick on "Create Account Button"

    And I should see "Accounts"
    And I should see "Test_account"
    And I fire_event_onclick on "Test_account_link"

    Then I click on "Create Task"
    And I enter text for "Task name"
    And I select "due_asap" from list
    And I select "presentation" from list
    Then I fire_event_onclick on "Create Task Button"

    Then I click the link with href "/accounts"
    And I fire_event_onclick on "Test_account_link"
    Then I click on "Create Contact"
    And I enter text for "Contact First name"
    And I enter text for "Contact Last name"
    And I enter text for "Contact Email"
    And I enter text for "Contact Phone"
    Then I fire_event_onclick on "Create Contact Button"

    Then I navigate to the environment url
    Then I click on "Tasks"
    And I should see "Test_task re: Test_account"
    Then I delete the task with "text" "Test_task"
    And I should see "Tasks"
    Then I reload the page
    And I should not see "Test_task"

    Then I click the link with href "/contacts"
    And I should see "John Doe at Test_account"
    And I fire_event_onclick on "Test_contact_link"
    And I click on "Delete"
    And I click on "Yes"
    And I should see "Contacts"
    Then I reload the page
    And I should not see "John Doe"

    Then I click the link with href "/accounts"
    And I should see "Test_account"
    And I fire_event_onclick on "Test_account_link"
    And I should not see "Test_task"
    And I should not see "John Doe"
    And I click on "Delete"
    And I click on "Yes"
    And I should see "Accounts"
    Then I reload the page
    And I should not see "Test_account"
    And I close the browser


