def inventory_page
  @inventory_page ||= InventoryPage.new
end

def cart_page
  @cart_page ||= CartPage.new
end

def checkout_page
  @checkout_page ||= CheckoutPage.new
end

When('I add the first {int} products to the cart') do |quantity|
  inventory_page.add_first_n_products_to_cart(quantity)
end

When('I navigate to the cart') do
  inventory_page.navigate_to_cart
end

Then('I should see the products page') do
  expect(current_url).to include('/inventory.html')
  expect(page).to have_content('Products')
  expect(page).to have_css('.inventory_item', minimum: 1)
end

When('I proceed to checkout') do
  cart_page.proceed_to_checkout
end

When('I enter the customer details {string}, {string}, and {string}') do |first_name, last_name, postal_code|
  checkout_page.fill_checkout_information(first_name, last_name, postal_code)
end

Then('I should see an error message {string}') do |message|
  checkout_page.verify_checkout_error_message(message)
end

Then('I should see the checkout overview page') do
  expect(current_url).to include('/checkout-step-two.html')
  expect(page).to have_content('Checkout: Overview')
end

Then('the total price should be correctly calculated based on subtotal and tax') do
  checkout_page.validate_financials(0.08)
end

When('I finish the purchase') do
  checkout_page.finish_purchase
end

Then('I should see the order confirmation page') do
  expect(current_url).to include('/checkout-complete.html')
  expect(page).to have_content('Thank you for your order!')
end