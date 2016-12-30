Feature: This feature file tests all the scenarios from Smoke_test tab on fatfreecrm.xlsx

  Background:
    Given I have a validate service URL to make "POST" request
    And   I read the data from the "fatfreecrm.xlsx" and "Smoke_test" tab

  Scenario: , Element = , Scenario ID = createAccount, API Name = accounts.json,
    When  I pass variables from row "createAccount"
    And   I make the "POST" REST-service call
    Then  I should see response from row "createAccount"

  Scenario: , Element = , Scenario ID = getAccountByAccountId, API Name = accounts/"ID".json,
    When  I pass variables from row "getAccountByAccountId"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getAccountByAccountId"

  Scenario: , Element = , Scenario ID = getAccounts, API Name = accounts.json,
    When  I pass variables from row "getAccounts"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getAccounts"

  Scenario: , Element = , Scenario ID = updateAccount, API Name = accounts/"ID".json,
    When  I pass variables from row "updateAccount"
    And   I make the "PUT" REST-service call
    Then  I should see response from row "updateAccount"

  Scenario: , Element = , Scenario ID = deleteAccount, API Name = accounts/"ID".json,
    When  I pass variables from row "deleteAccount"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "deleteAccount"

  Scenario: , Element = , Scenario ID = createTask, API Name = tasks.json,
    When  I pass variables from row "createTask"
    And   I make the "POST" REST-service call
    Then  I should see response from row "createTask"

  Scenario: , Element = , Scenario ID = getTaskByTaskId, API Name = tasks/"ID".json,
    When  I pass variables from row "getTaskByTaskId"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getTaskByTaskId"

  Scenario: , Element = , Scenario ID = getTasks, API Name = tasks.json,
    When  I pass variables from row "getTasks"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getTasks"

  Scenario: , Element = , Scenario ID = updateTask, API Name = tasks/"ID".json,
    When  I pass variables from row "updateTask"
    And   I make the "PUT" REST-service call
    Then  I should see response from row "updateTask"

  Scenario: , Element = , Scenario ID = deleteTask, API Name = tasks/"ID".json,
    When  I pass variables from row "deleteTask"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "deleteTask"

  Scenario: , Element = , Scenario ID = createCampaign, API Name = campaigns.json,
    When  I pass variables from row "createCampaign"
    And   I make the "POST" REST-service call
    Then  I should see response from row "createCampaign"

  Scenario: , Element = , Scenario ID = getCampaignByCampaignId, API Name = campaigns/"ID".json,
    When  I pass variables from row "getCampaignByCampaignId"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getCampaignByCampaignId"

  Scenario: , Element = , Scenario ID = getCampaigns, API Name = campaigns.json,
    When  I pass variables from row "getCampaigns"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getCampaigns"

  Scenario: , Element = , Scenario ID = updateCampaign, API Name = campaigns/"ID".json,
    When  I pass variables from row "updateCampaign"
    And   I make the "PUT" REST-service call
    Then  I should see response from row "updateCampaign"

  Scenario: , Element = , Scenario ID = deleteCampaign, API Name = campaigns/"ID".json,
    When  I pass variables from row "deleteCampaign"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "deleteCampaign"

  Scenario: , Element = , Scenario ID = createLead, API Name = leads.json,
    When  I pass variables from row "createLead"
    And   I make the "POST" REST-service call
    Then  I should see response from row "createLead"

  Scenario: , Element = , Scenario ID = getLeadByLeadId, API Name = leads/"ID".json,
    When  I pass variables from row "getLeadByLeadId"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getLeadByLeadId"

  Scenario: , Element = , Scenario ID = getLeads, API Name = leads.json,
    When  I pass variables from row "getLeads"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getLeads"

  Scenario: , Element = , Scenario ID = updateLead, API Name = leads/"ID".json,
    When  I pass variables from row "updateLead"
    And   I make the "PUT" REST-service call
    Then  I should see response from row "updateLead"

  Scenario: , Element = , Scenario ID = deleteLead, API Name = leads/"ID".json,
    When  I pass variables from row "deleteLead"
    And   I make the "DELETE" REST-service call
    Then  I should see response from row "deleteLead"

  Scenario: , Element = , Scenario ID = getContacts, API Name = contacts.json,
    When  I pass variables from row "getContacts"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getContacts"

  Scenario: , Element = , Scenario ID = getOpportunities, API Name = opportunities.json,
    When  I pass variables from row "getOpportunities"
    And   I make the "GET" REST-service call
    Then  I should see response from row "getOpportunities"
