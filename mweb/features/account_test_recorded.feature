Feature: We will test Fat Free CRM for functionality.

  Background:
    Then I open a chrome browser
    Then I clear cookies
    When I navigate to the environment url


  Scenario: Here we create a new Account and delete it..
    Then I enter "admin" in text field with "id" "authentication_username"
    Then I enter "password" in text field with "id" "authentication_password"
    Then I fire_event_onclick the "button" with "text" "Login"

    And I should see "My Tasks"
    Then I click the "link" with "text" "Tasks"
    Then I click the link with href "/accounts"
#    Then I click the "link" with "href" "/accounts"
    And I should see "Accounts"
    And I should not see "Test_account"
    Then I click the "span" with "id" "create_account_arrow"
    Then I enter "Test_account" in the text field with "id" "account_name"
    Then I select the value "customer" in select list with "id" "account_category"
    Then I select the value "5" in select list with "id" "account_rating"
    Then I fire_event_onclick the "button" with "text" "Create Account"

    Then I fire_event_onclick the "link" with "text" "Test_account"
    Then I click the "link" with "text" "Delete?"
    Then I click the "link" with "text" "Yes"
    And I should see "Accounts"
    Then I reload the page
    And I should not see "Test_account"
    And I close the browser


  Scenario: Here we create a new Account with no name and expect to see the error message
    Then I enter "admin" in text field with "id" "authentication_username"
    Then I enter "password" in text field with "id" "authentication_password"
    Then I fire_event_onclick the "button" with "text" "Login"

    And I should see "My Tasks"
    Then I click the "link" with "text" "Tasks"
#    Then I click the "link" with "text" "Accounts"
    Then I click the link with href "/accounts"
#    Then I fire_event_onclick the "link" with "href" "/accounts"
#    Then I click the "link" with "href" "/accounts"
    And I should see "Accounts"
    And I should not see "Test_account"
    Then I click the "span" with "id" "create_account_arrow"
    Then I fire_event_onclick the "button" with "text" "Create Account"
    And I should see "Please specify account name"
    And I close the browser




