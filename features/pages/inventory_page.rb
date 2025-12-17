require_relative 'Form'

class InventoryPage < Form
  PRODUCT_MAPPING = {
    "Sauce Labs Backpack" => "sauce-labs-backpack",
    "Sauce Labs Bike Light" => "sauce-labs-bike-light", 
    "Sauce Labs Bolt T-Shirt" => "sauce-labs-bolt-t-shirt",
    "Sauce Labs Fleece Jacket" => "sauce-labs-fleece-jacket",
    "Sauce Labs Onesie" => "sauce-labs-onesie",
    "Test.allTheThings() T-Shirt (Red)" => "test.allthethings()-t-shirt-(red)"
  }

  def visit_page
    visit '/inventory.html'
  end

  def verify_inventory_page
    expect(page).to have_content('Products')
    expect(page).to have_css('.inventory_list')
    expect(current_url).to include('inventory')
  end

  def add_item_to_cart(item_name)
    product_id = PRODUCT_MAPPING[item_name]
    
    if product_id.nil?
      raise "Producto '#{item_name}' no encontrado en el mapeo. Productos disponibles: #{PRODUCT_MAPPING.keys.join(', ')}"
    end
    
    button_selector = "[data-test='add-to-cart-#{product_id}']"
    
    find(button_selector, wait: 10).click
    
    sleep 0.3
  end

  def add_multiple_items_to_cart(items_table)
    items_data = items_table.raw
    
    first_cell = items_data[0][0]
    is_header = first_cell == "Item Name" || first_cell == "item_name"
    
    if is_header
      items_to_add = items_data[1..-1]
    else
      items_to_add = items_data
    end
    
    items_to_add.each do |row|
      item_name = row[0]
      puts "Agregando item: #{item_name}"
      add_item_to_cart(item_name)
    end
  end

  def remove_item_from_cart(item_name)
    product_id = PRODUCT_MAPPING[item_name]
    
    if product_id.nil?
      raise "Producto '#{item_name}' no encontrado en el mapeo"
    end
    
    remove_button_selector = "[data-test^='remove-#{product_id}']"
    
    find(remove_button_selector, wait: 10).click
    
    sleep 0.3
  end

  def remove_multiple_items_from_cart(items_table)
    items_data = items_table.raw
    
    first_cell = items_data[0][0]
    is_header = first_cell == "Item Name" || first_cell == "item_name"
    
    if is_header
      items_to_remove = items_data[1..-1]
    else
      items_to_remove = items_data
    end
    
    items_to_remove.each do |row|
      item_name = row[0]
      puts "Removiendo item: #{item_name}"
      remove_item_from_cart(item_name)
    end
  end

  def verify_cart_count(expected_count)
    sleep 0.5
    
    if expected_count > 0
      cart_badge = find('.shopping_cart_link .shopping_cart_badge', wait: 10)
      actual_count = cart_badge.text.to_i
      
      if actual_count != expected_count
        sleep 1 
        actual_count = find('.shopping_cart_link .shopping_cart_badge').text.to_i
      end
      
      expect(actual_count).to eq(expected_count), 
        "Expected cart to have #{expected_count} items, but found #{actual_count}"
    else
      expect(page).to have_css('.shopping_cart_link')
      
      if page.has_css?('.shopping_cart_badge', wait: 2)
        actual_count = find('.shopping_cart_badge').text.to_i
        raise "Expected empty cart but found #{actual_count} items"
      end
    end
  end

  def verify_cart_is_empty
    verify_cart_count(0)
  end

  def verify_item_added_to_cart(item_name)
    product_id = PRODUCT_MAPPING[item_name]
    
    if product_id.nil?
      raise "Producto '#{item_name}' no encontrado en el mapeo"
    end
    
    remove_button_selector = "[data-test^='remove-#{product_id}']"
    
    begin
      sleep 0.5
      
      button = find(remove_button_selector, wait: 10)
      
      expect(button.text).to eq('Remove'), 
        "Expected button text to be 'Remove' but found '#{button.text}'"
        
    rescue Capybara::ElementNotFound
      add_button_selector = "[data-test^='add-to-cart-#{product_id}']"
      
      if page.has_css?(add_button_selector, wait: 2)
        button = find(add_button_selector)
        raise "El botón todavía dice '#{button.text}' en lugar de 'Remove'"
      else
        raise "No se encontró ningún botón para el producto #{item_name}"
      end
    end
  end

  def verify_item_not_in_cart(item_name)
    product_id = PRODUCT_MAPPING[item_name]
    
    if product_id.nil?
      raise "Producto '#{item_name}' no encontrado en el mapeo"
    end
    
    add_button_selector = "[data-test^='add-to-cart-#{product_id}']"
    
    begin
      button = find(add_button_selector, wait: 10)
      expect(button.text).to eq('Add to cart'), 
        "Expected button text to be 'Add to cart' but found '#{button.text}'"
    rescue Capybara::ElementNotFound
      raise "No se encontró el botón 'Add to cart' para #{item_name}"
    end
  end

  def get_item_price(item_name)
    product_element = find('.inventory_item', text: /#{Regexp.escape(item_name)}/i, match: :first)
    price_text = product_element.find('[data-test="inventory-item-price"]').text
    clean_currency_format(price_text)
  end
  
  def get_cart_item_count
    if has_css?('.shopping_cart_link .shopping_cart_badge', wait: 2)
      find('.shopping_cart_link .shopping_cart_badge').text.to_i
    else
      0
    end
  end
end