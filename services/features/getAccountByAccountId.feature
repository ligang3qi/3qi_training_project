Feature: This feature file tests all the scenarios from getAccountByAccountId tab on fatfreecrm.xlsx

  Background:
    Given I have a validate service URL to make "POST" request
    And   I read the data from the "fatfreecrm.xlsx" and "getAccountByAccountId" tab

  @#1
  Scenario: post an account, Element = name, Scenario ID = s_001, API Name = accounts.json,
    When  I pass variables from row "s_001"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_001"

  @#2
  Scenario: get posted account, Element = name, Scenario ID = s_002, API Name = accounts/"ID".json,
    When  I pass variables from row "s_002"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_002"

  @#3
  Scenario: invalid, get deleted account, Element = name, Scenario ID = s_003, API Name = accounts/"ID".json,
    When  I pass variables from row "s_003"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_003"

  @#4
  Scenario: invalid, use a string as ID, Element = name, Scenario ID = s_004, API Name = accounts/a.json,
    When  I pass variables from row "s_004"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_004"

  @#5
  Scenario: invalid, use null as ID, Element = name, Scenario ID = s_005, API Name = accounts/.json,
    When  I pass variables from row "s_005"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_005"

  @#6
  Scenario: invalid, use negative number as ID, Element = name, Scenario ID = s_006, API Name = accounts/-1.json,
    When  I pass variables from row "s_006"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_006"

  @#7
  Scenario: failed test, use negative number as ID but expect to receive 200, Element = name, Scenario ID = s_007, API Name = accounts/-1.json,
    When  I pass variables from row "s_007"
    And   I make the "GET" REST-service call
    Then  I should see response from row "s_007"
