Feature: This feature file tests all the scenarios from functional_flow tab on fatfreecrm.xlsx

  Background:
    Given I have a validate service URL to make "POST" request
    And   I read the data from the "fatfreecrm.xlsx" and "functional_flow" tab

  @#1_
  Scenario: Create/update/delete and vefiry with getUser, Element = , Scenario ID = s_001, API Name = accounts.json,
    When  I pass variables from row "s_001"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_001"

  @#1_
  Scenario: verify created user, capture date from headers, Element = , Scenario ID = s_002, API Name = accounts/"ID".json,
    When  I pass variables from row "s_002"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_002"

  @#1_
  Scenario: updte all values, insert the date captured from headers into the last name, Element = , Scenario ID = s_003, API Name = accounts/"ID".json,
    When  I pass variables from row "s_003"
    And   I make the "PUT" REST-service call
    Then  I should see response from row "s_003"

  @#1_
  Scenario: verify values updated, Element = , Scenario ID = s_004, API Name = accounts/"ID".json,
    When  I pass variables from row "s_004"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_004"

  @#1_
  Scenario: delete user, Element = , Scenario ID = s_005, API Name = accounts/"ID".json,
    When  I pass variables from row "s_005"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "s_005"

  @#1_
  Scenario: verify deleted user, Element = , Scenario ID = s_006, API Name = accounts/"ID".json,
    When  I pass variables from row "s_006"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_006"
