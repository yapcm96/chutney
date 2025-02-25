@disableUnknownVariable
Feature: Avoid Outline for single example

  As a Business Analyst
  I do not want a Scenario Outline to be used for a single example
  So that the feature is easier to read
  
  Background:
    Given chutney is configured with the linter "Chutney::AvoidOutlineForSingleExample"
  
  Scenario: A valid example
    And a feature file contains:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>
          
        Examples: Valid
          | A | B |
          | a | b |
          | c | d |
      """
    When I run Chutney
    Then 0 issues are raised
  
  Scenario: Outline with a single example
    And a feature file contains:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>
          
        Examples: Invalid
          | A | B |
          | a | b |
      """
    When I run Chutney
    Then 1 issue is raised
    And the message is: 
      """
      Avoid using Scenario Outlines when you only have a single example. Use a Scenario instead.
      """
    And it is reported on:
      | line | column |
      | 2    | 3      |

  Scenario: Defect Test - Empty Feature
    And a feature file contains:
      """
      """
    When I run Chutney
    Then 0 issues are raised


  Scenario: A void running lint if the example table does not exist
    And a feature file contains:
      """
      Feature: Test
        Scenario Outline: A
          When <A>
          Then <B>
      """
    When I run Chutney
    Then 0 issues are raised