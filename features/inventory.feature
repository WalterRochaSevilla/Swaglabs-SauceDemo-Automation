Feature: Module B - Shopping Cart Management
  As an authenticated user
  I want to add products to my shopping cart
  So I can proceed to checkout

  Background:
    Given I am logged in as "standard_user" on the Inventory Page

  # ========== SCENARIOS PARA AGREGAR ITEMS ==========
  @smoke @cart @positive
  Scenario: Add a single item to the cart
    When I add the item "Sauce Labs Backpack" to the cart
    Then I should see 1 item in the cart
    And the item "Sauce Labs Backpack" should be successfully added
    And I should remain on the Inventory Page

  @cart @positive
  Scenario: Add multiple items to the cart
    When I add the following items to the cart:
      | Sauce Labs Backpack           |
      | Sauce Labs Bike Light         |
      | Sauce Labs Bolt T-Shirt       |
    Then I should see 3 items in the cart
    And I should remain on the Inventory Page

  @cart @positive
  Scenario Outline: Add different product types to cart
    When I add the item "<item_name>" to the cart
    Then I should see 1 item in the cart
    And the item "<item_name>" should be successfully added
    And I should remain on the Inventory Page

    Examples:
      | item_name                               |
      | Sauce Labs Backpack                     |
      | Sauce Labs Bike Light                   |
      | Sauce Labs Bolt T-Shirt                 |
      | Sauce Labs Fleece Jacket                |
      | Sauce Labs Onesie                       |
      | Test.allTheThings() T-Shirt (Red)       |

  @cart @edge
  Scenario: Verify empty cart initially
    Then I should see the cart is empty

  @cart @regression
  Scenario: Add all available items to cart
    When I add the following items to the cart:
      | Sauce Labs Backpack                     |
      | Sauce Labs Bike Light                   |
      | Sauce Labs Bolt T-Shirt                 |
      | Sauce Labs Fleece Jacket                |
      | Sauce Labs Onesie                       |
      | Test.allTheThings() T-Shirt (Red)       |
    Then the cart icon should show 6 items

  # ========== SCENARIOS PARA REMOVER ITEMS ==========
  @cart @positive @remove
  Scenario: Add and then remove a single item from cart
    When I add the item "Sauce Labs Backpack" to the cart
    Then I should see 1 item in the cart
    And the item "Sauce Labs Backpack" should be successfully added
    When I remove the item "Sauce Labs Backpack" from the cart
    Then I should see the cart is empty
    And the item "Sauce Labs Backpack" should not be in the cart

  @cart @positive @remove
  Scenario: Add multiple items and remove one from cart
    When I add the following items to the cart:
      | Sauce Labs Backpack   |
      | Sauce Labs Bike Light |
      | Sauce Labs Bolt T-Shirt |
    Then I should see 3 items in the cart
    When I remove the item "Sauce Labs Bike Light" from the cart
    Then I should see 2 items in the cart
    And the item "Sauce Labs Bike Light" should not be in the cart
    And the item "Sauce Labs Backpack" should be successfully added
    And the item "Sauce Labs Bolt T-Shirt" should be successfully added

  @cart @positive @remove
  Scenario: Add and remove all items from cart
    When I add the following items to the cart:
      | Sauce Labs Backpack   |
      | Sauce Labs Bike Light |
    Then I should see 2 items in the cart
    When I remove the following items from the cart:
      | Sauce Labs Backpack   |
      | Sauce Labs Bike Light |
    Then I should see the cart is empty

  @cart @edge @remove
  Scenario: Try to remove item from empty cart
    Given the cart is empty
    Then I should see the cart is empty
    # Note: No hay acción de remover porque no hay items

  @cart @regression @remove
  Scenario: Complex cart management workflow
    Given the cart is empty
    When I add the item "Sauce Labs Fleece Jacket" to the cart
    Then I should see 1 item in the cart
    And the item "Sauce Labs Fleece Jacket" should be successfully added
    
    When I add the item "Sauce Labs Onesie" to the cart
    Then I should see 2 items in the cart
    And the item "Sauce Labs Onesie" should be successfully added
    
    When I remove the item "Sauce Labs Fleece Jacket" from the cart
    Then I should see 1 item in the cart
    And the item "Sauce Labs Fleece Jacket" should not be in the cart
    And the item "Sauce Labs Onesie" should be successfully added
    
    When I add the item "Test.allTheThings() T-Shirt (Red)" to the cart
    Then I should see 2 items in the cart
    And the item "Test.allTheThings() T-Shirt (Red)" should be successfully added
    
    When I remove the following items from the cart:
      | Sauce Labs Onesie                       |
      | Test.allTheThings() T-Shirt (Red)       |
    Then I should see the cart is empty