Feature: I want to test a web-based CRM application.

  Background:
    Then I open a chrome browser
    Then I clear cookies
    And I read the data from the "fat_free_crm.xlsx"
    When I navigate to the environment url


  Scenario: Here we verify Dashboard display all expected components
    Given I enter text for "admin_u"
    And I enter text for "admin_p"
    Then I fire_event_onclick on "Login"

    And I should see "My Tasks"
    And I should see "My Opportunities"
    And I should see "My Accounts"
    And I should see "Recent Activity"
    And I should see "Profile"
    And I should see "Logout"
    And I close the browser


