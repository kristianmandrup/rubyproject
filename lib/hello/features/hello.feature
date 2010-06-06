Feature: hello ...
  As a user
  I want to ...
  In order to ...

  Scenario Outline: do it
    Given the secret code is "<code>"
    When I guess "<guess>"            
    Then the mark should be "<mark>"
      
    Scenarios: no matches
      | code | guess | mark |
      | 1234 | 5678  |      |
      | 1234 | 5678  |      |
    