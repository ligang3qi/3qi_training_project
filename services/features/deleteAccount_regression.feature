Feature: This feature file tests all the scenarios from deleteAccount_regression tab on fatfreecrm.xlsx

  Background:
    Given I have a validate service URL to make "POST" request
    And   I read the data from the "fatfreecrm.xlsx" and "deleteAccount_regression" tab

  @#1
  Scenario: post an account, Element = name, Scenario ID = s_001, API Name = accounts.json,
    When  I pass variables from row "s_001"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_001"

  @#2
  Scenario: delete an account, Element = , Scenario ID = s_002, API Name = accounts/"ID".json,
    When  I pass variables from row "s_002"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "s_002"

  @#3
  Scenario: invalid, delete an deleted account, Element = , Scenario ID = s_003, API Name = accounts/"ID".json,
    When  I pass variables from row "s_003"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "s_003"

  @#4
  Scenario: failed test, delete an deleted account and expect 204, Element = , Scenario ID = s_004, API Name = accounts/"ID".json,
    When  I pass variables from row "s_004"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "s_004"
