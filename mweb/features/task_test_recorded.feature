Feature: We will test Fat Free CRM for functionality.

  Background:
    Then I open a chrome browser
    Then I clear cookies
    When I navigate to the environment url


  Scenario: Here we create a new task and delete it..
    Then I enter "admin" in text field with "id" "authentication_username"
    Then I enter "password" in text field with "id" "authentication_password"
    Then I fire_event_onclick the "button" with "text" "Login"
    And I should see "My Tasks"
    Then I click the "link" with "text" "Tasks"

    And I should see "Tasks"
    And I should not see "Test_task"
    Then I click the "span" with "id" "create_task_arrow"

    And I should see "Create Task"
    Then I enter "Test_task" in the text field with "id" "task_name"
    Then I select the value "due_asap" in select list with "id" "task_bucket"
#    Then I tap the "div" with "id" "s2id_task_assigned_to"
#    Then I enter "myself" in Assigned to input box
#    Then I press enter
    Then I select the value "meeting" in select list with "id" "task_category"
    Then I fire_event_onclick the "button" with "text" "Create Task"

    And I should see "Test_task"
    Then I reload the page
    Then I navigate to the environment url
    Then I click the "link" with "text" "Tasks"
    And I should see "Test_task"
    Then I delete the task with "text" "Test_task"
    And I should see "Tasks"
    Then I reload the page
    And I should not see "Test_task"
    And I close the browser


