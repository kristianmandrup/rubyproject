Feature: #{app_name} ...
  As a user
  I want to ...
  In order to ...

  Scenario: do it
    Given the secret code is "code"
    When I guess "guess"
    Then the mark should be "mark"
    And the result should be "win"
  
  # Scenario Outline: submit guess
  #   Given the secret code is "<code>"
  #   When I guess "<guess>"
  #   Then the mark should be "<mark>"
    
  # Scenarios: no matches
  #   | code | guess | mark |
  #   | 1234 | 5678  |      |
  #   | 1234 | 5678  |      |
    