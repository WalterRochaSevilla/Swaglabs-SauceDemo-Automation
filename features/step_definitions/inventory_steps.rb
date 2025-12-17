puts "Cargando inventory_steps.rb..."

def inventory_page
  @inventory_page ||= InventoryPage.new
end

def login_page
  @login_page ||= LoginPage.new
end

Given('I am logged in as {string} on the Inventory Page') do |user_type|
  login_page.visit_page
  login_page.login_as(user_type, 'secret_sauce')
  
  # Verificar que estamos en la página de inventario
  inventory_page.verify_inventory_page
  
  # Limpiar el carrito antes de comenzar (si hay items)
  cleanup_cart
end

When('I add the following items to the cart:') do |items_table|
  inventory_page.add_multiple_items_to_cart(items_table)
end

When('I add the item {string} to the cart') do |item_name|
  inventory_page.add_item_to_cart(item_name)
end

# Step que captura tanto "item" como "items" con expresión regular
Then(/^I should see (\d+) item(?:s)? in the cart$/) do |expected_count|
  inventory_page.verify_cart_count(expected_count.to_i)
end

Then('I should see the cart is empty') do
  inventory_page.verify_cart_is_empty
end

Then('the item {string} should be successfully added') do |item_name|
  inventory_page.verify_item_added_to_cart(item_name)
end

Then('I should remain on the Inventory Page') do
  inventory_page.verify_inventory_page
end

Then('the cart icon should show {int} items') do |expected_count|
  inventory_page.verify_cart_count(expected_count)
end

# ========== NUEVOS STEPS PARA REMOVER ITEMS ==========

When('I remove the item {string} from the cart') do |item_name|
  inventory_page.remove_item_from_cart(item_name)
end

When('I remove the following items from the cart:') do |items_table|
  inventory_page.remove_multiple_items_from_cart(items_table)
end

Then('the item {string} should not be in the cart') do |item_name|
  inventory_page.verify_item_not_in_cart(item_name)
end

Given('the cart is empty') do
  # Asegurar que el carrito está vacío
  cleanup_cart
  
  # Verificar que efectivamente está vacío
  inventory_page.verify_cart_is_empty
end

# ========== HELPER METHODS ==========

# Helper method para limpiar el carrito
def cleanup_cart
  # Pequeña pausa para asegurar que la página está cargada
  sleep 0.5
  
  # Contar cuántos items hay en el carrito
  item_count = inventory_page.get_cart_item_count
  
  if item_count > 0
    puts "Limpiando #{item_count} items del carrito antes del test..."
    
    # Intentar remover cualquier item que esté en el carrito
    while page.has_css?('[data-test^="remove-"]', wait: 2)
      all('[data-test^="remove-"]').first.click
      sleep 0.3
    end
    
    sleep 0.5  # Esperar que se actualice
    
    # Verificar que quedó vacío
    final_count = inventory_page.get_cart_item_count
    puts "Carrito limpiado. Items restantes: #{final_count}" if final_count > 0
  end
end