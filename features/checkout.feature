@checkout @financial
Feature: Checkout and Financial Logic
  As a customer
  I want to complete a purchase
  And ensure that the financial calculations are correct.

  Background:
    Given I navigate to the Sauce Demo Login Page
    When I attempt to login with user "standard_user" and password "secret_sauce"
    And I add the first 1 products to the cart
    And I navigate to the cart
    And I proceed to checkout

  @validation @negative
  Scenario Outline: Validate required fields in Checkout Information
    When I enter the customer details "<first_name>", "<last_name>", and "<zip>"
    Then I should see an error message "<error_message>"

    Examples:
      | first_name | last_name | zip   | error_message                  |
      |            | Doe       | 12345 | Error: First Name is required  |
      | John       |           | 12345 | Error: Last Name is required   |
      | John       | Doe       |       | Error: Postal Code is required |

  @e2e @positive
  Scenario: Complete checkout process and verify financial calculations
    When I enter the customer details "John", "Doe", and "12345"
    Then I should see the checkout overview page
    And the total price should be correctly calculated based on subtotal and tax
    When I finish the purchase
    Then I should see the order confirmation page