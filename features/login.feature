Feature: Module A - User Authentication
  As a system user
  I want to authenticate into Swag Labs
  To access the product inventory

  Background:
    Given I am on the Sauce Demo Login Page

  @smoke @login @positive
  Scenario Outline: Successful login with multiple user profiles
    When I attempt to login with user "<username>" and password "secret_sauce"
    Then I should be redirected to the Inventory Page

    Examples:
      | username                | description                   |
      | standard_user           | Standard User (Happy Path)    |
      | problem_user            | User with broken images       |
      | performance_glitch_user | User with performance delays  |
      | error_user              | User with JS errors           |
      | visual_user             | User with visual glitches     |

  @smoke @login @negative
  Scenario: Security lock validation for restricted user
    When I attempt to login with user "locked_out_user" and password "secret_sauce"
    Then I should see a locked out error message

  @smoke @login @validation
  Scenario: Login validation for empty credentials
    When I click login without entering credentials
    Then I should see a required field error

  @smoke @logout @quit
  Scenario: User can logout successfully
    Given I attempt to login with user "standard_user" and password "secret_sauce"
    When I log out from the application
    Then I should be returned to the Login Page