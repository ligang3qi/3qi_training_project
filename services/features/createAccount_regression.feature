Feature: This feature file tests all the scenarios from createAccount_regression tab on fatfreecrm.xlsx

  Background:
    Given I have a validate service URL to make "POST" request
    And   I read the data from the "fatfreecrm.xlsx" and "createAccount_regression" tab

  @#1
  Scenario: 64 char max, Element = name, Scenario ID = s_001, API Name = accounts.json,
    When  I pass variables from row "s_001"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_001"

  @#2
  Scenario: invalid, 65 char more than max, Element = name, Scenario ID = s_002, API Name = accounts.json,
    When  I pass variables from row "s_002"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_002"

  @#3
  Scenario: with space, Element = name, Scenario ID = s_003, API Name = accounts.json,
    When  I pass variables from row "s_003"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_003"

  @#4
  Scenario: array, Element = name, Scenario ID = s_004, API Name = accounts.json,
    When  I pass variables from row "s_004"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_004"

  @#5
  Scenario: invalid type, empty string, Element = name, Scenario ID = s_005, API Name = accounts.json,
    When  I pass variables from row "s_005"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_005"

  @#6
  Scenario: invalid type, empty array, Element = name, Scenario ID = s_006, API Name = accounts.json,
    When  I pass variables from row "s_006"
    And   I make the "POST" REST-service call
    Then  I should see response from row "s_006"
