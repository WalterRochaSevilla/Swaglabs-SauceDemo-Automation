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
  puts "Adding the first #{quantity} products to the cart"
  inventory_page.add_first_n_products_to_cart(quantity)
end

When('I navigate to the cart') do
  puts "Navigating to the cart"
  inventory_page.navigate_to_cart
end

Then('I should see the products page') do
  expect(page).to have_current_path('/inventory.html', url: true)
  expect(page).to have_content('Products')
  expect(page).to have_css('.inventory_item', minimum: 1)
  puts "Successfully navigated to Products page with items displayed"
end

When('I proceed to checkout') do
  puts "Proceeding to checkout"
  cart_page.proceed_to_checkout
end

When('I enter the customer details {string}, {string}, and {string}') do |first_name, last_name, postal_code|
  puts "Entering customer details"
  checkout_page.fill_checkout_information(first_name, last_name, postal_code)
end

When('I continue to the checkout overview') do
  puts "Continuing to checkout overview"
  # This step is now handled by fill_checkout_information in the previous step
  # We can keep it as an empty step for readability or remove it from the .feature file
end

Then('I should see the checkout overview page') do
  expect(page).to have_current_path('/checkout-step-two.html', url: true)
  expect(page).to have_content('Checkout: Overview')
  puts "Successfully on the checkout overview page"
end

Then('the total price should be correctly calculated based on subtotal and tax') do
  checkout_page.validate_financials(0.08) # Assuming 8% tax rate as per your requirements
end

When('I finish the purchase') do
  puts "Finishing the purchase"
  checkout_page.finish_purchase
end

Then('I should see the order confirmation page') do
  expect(page).to have_current_path('/checkout-complete.html', url: true)
  expect(page).to have_content('Thank you for your order!')
  puts "Successfully on the order confirmation page"
end
