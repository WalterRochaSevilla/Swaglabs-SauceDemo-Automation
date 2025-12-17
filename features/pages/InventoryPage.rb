require_relative 'Form'

class InventoryPage < Form
  # --- CONSTANTES Y SELECTORES ---
  ADD_TO_CART_BUTTON_GENERIC = '.btn_inventory'
  CART_BADGE = '.shopping_cart_badge'
  
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

  # --- MÉTODOS DEL INVENTARIO AVANZADO ---
  
  def add_item_to_cart(item_name)
    product_id = PRODUCT_MAPPING[item_name]
    raise "Producto '#{item_name}' no encontrado." if product_id.nil?
    
    button_selector = "[data-test='add-to-cart-#{product_id}']"
    find(button_selector, wait: 10).click
  end

  def add_multiple_items_to_cart(items_table)
    items_data = items_table.raw
    # Detectar si hay header y eliminarlo
    items_to_add = (items_data[0][0].match?(/Item Name/i)) ? items_data[1..-1] : items_data
    
    items_to_add.each do |row|
      add_item_to_cart(row[0])
    end
  end

  # --- MÉTODOS LEGACY (Soportan tus steps antiguos) ---
  def add_first_n_products_to_cart(count)
    expect(page).to have_selector(ADD_TO_CART_BUTTON_GENERIC, wait: 10)
    page.all(ADD_TO_CART_BUTTON_GENERIC).first(count).each(&:click)
    # Validar que el badge se actualice
    expect(page).to have_selector(CART_BADGE, text: count.to_s, wait: 5)
  end

  def navigate_to_cart
    if page.has_css?(CART_BADGE)
        find(CART_BADGE).click
    else
        find('.shopping_cart_link').click
    end
  end

  # --- MÉTODOS DE LIMPIEZA Y VALIDACIÓN ---

  def remove_item_from_cart(item_name)
    product_id = PRODUCT_MAPPING[item_name]
    find("[data-test^='remove-#{product_id}']", wait: 10).click
  end
  
  def remove_multiple_items_from_cart(items_table)
    items_data = items_table.raw
    items_to_remove = (items_data[0][0].match?(/Item Name/i)) ? items_data[1..-1] : items_data
    items_to_remove.each { |row| remove_item_from_cart(row[0]) }
  end

  def verify_cart_count(expected_count)
    if expected_count > 0
      expect(page).to have_selector(CART_BADGE, text: expected_count.to_s, wait: 10)
    else
      expect(page).to_not have_selector(CART_BADGE)
    end
  end

  def verify_cart_is_empty
    verify_cart_count(0)
  end

  def get_cart_item_count
    return 0 unless page.has_css?(CART_BADGE, wait: 2)
    find(CART_BADGE).text.to_i
  end
  
  # Validaciones de estado del botón (Add vs Remove)
  def verify_item_added_to_cart(item_name)
     product_id = PRODUCT_MAPPING[item_name]
     expect(page).to have_selector("[data-test^='remove-#{product_id}']", wait: 5)
  end

  def verify_item_not_in_cart(item_name)
     product_id = PRODUCT_MAPPING[item_name]
     expect(page).to have_selector("[data-test^='add-to-cart-#{product_id}']", wait: 5)
  end
end