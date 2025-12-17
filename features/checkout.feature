# language: en
@checkout @financial
Feature: Checkout and Financial Logic
  As a customer
  I want to complete a purchase
  And ensure that the financial calculations are correct.

  Background:
    Given I navigate to the Sauce Demo Login Page
    When I attempt to login with user "standard_user" and password "secret_sauce"
    And I add the first 2 products to the cart
    And I navigate to the cart

  @e2e
  Scenario: Complete checkout process and verify financial calculations
    When I proceed to checkout
    And I enter the customer details "John", "Doe", and "12345"
    Then I should see the checkout overview page
    And the total price should be correctly calculated based on subtotal and tax
    When I finish the purchase
    Then I should see the order confirmation page