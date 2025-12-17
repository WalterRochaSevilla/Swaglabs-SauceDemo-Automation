require_relative 'Form'

class InventoryPage < Form
  # Mapeo de nombres de productos a sus data-test attributes
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
    # Obtener el identificador del producto del mapeo
    product_id = PRODUCT_MAPPING[item_name]
    
    if product_id.nil?
      raise "Producto '#{item_name}' no encontrado en el mapeo. Productos disponibles: #{PRODUCT_MAPPING.keys.join(', ')}"
    end
    
    button_selector = "[data-test='add-to-cart-#{product_id}']"
    
    # Esperar a que el botón sea visible y hacer clic
    find(button_selector, wait: 10).click
    
    # Pequeña pausa para asegurar que se actualice
    sleep 0.3
  end

  def add_multiple_items_to_cart(items_table)
    # Usar el método 'transpose' para manejar correctamente la tabla
    items_data = items_table.raw
    
    # Determinar si la primera fila es encabezado
    first_cell = items_data[0][0]
    is_header = first_cell == "Item Name" || first_cell == "item_name"
    
    if is_header
      # Saltar el encabezado
      items_to_add = items_data[1..-1]
    else
      # Usar todos los datos
      items_to_add = items_data
    end
    
    # Agregar cada item
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
    
    # Esperar a que el botón Remove sea visible y hacer clic
    find(remove_button_selector, wait: 10).click
    
    # Pequeña pausa para asegurar que se actualice
    sleep 0.3
  end

  def remove_multiple_items_from_cart(items_table)
    items_data = items_table.raw
    
    # Determinar si la primera fila es encabezado
    first_cell = items_data[0][0]
    is_header = first_cell == "Item Name" || first_cell == "item_name"
    
    if is_header
      # Saltar el encabezado
      items_to_remove = items_data[1..-1]
    else
      # Usar todos los datos
      items_to_remove = items_data
    end
    
    # Remover cada item
    items_to_remove.each do |row|
      item_name = row[0]
      puts "Removiendo item: #{item_name}"
      remove_item_from_cart(item_name)
    end
  end

  def verify_cart_count(expected_count)
    # Pequeña pausa para permitir que se actualice el DOM
    sleep 0.5
    
    # Buscar el badge del carrito
    if expected_count > 0
      cart_badge = find('.shopping_cart_link .shopping_cart_badge', wait: 10)
      actual_count = cart_badge.text.to_i
      
      # Intento de recuperación si la cuenta no coincide
      if actual_count != expected_count
        sleep 1  # Esperar un poco más
        actual_count = find('.shopping_cart_link .shopping_cart_badge').text.to_i
      end
      
      expect(actual_count).to eq(expected_count), 
        "Expected cart to have #{expected_count} items, but found #{actual_count}"
    else
      # Para 0 items, verificar que no hay badge
      expect(page).to have_css('.shopping_cart_link')
      
      # Verificar que no existe el badge
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
    
    # El botón cambia de "Add to cart" a "Remove" después de agregar
    remove_button_selector = "[data-test^='remove-#{product_id}']"
    
    # Esperar a que aparezca el botón "Remove"
    begin
      # Primero esperar un poco
      sleep 0.5
      
      # Buscar el botón Remove
      button = find(remove_button_selector, wait: 10)
      
      # Verificar que el texto sea "Remove"
      expect(button.text).to eq('Remove'), 
        "Expected button text to be 'Remove' but found '#{button.text}'"
        
    rescue Capybara::ElementNotFound
      # Si no encontramos "Remove", quizás todavía está en "Add to cart"
      # Esto podría indicar un problema
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
    
    # Después de remover, el botón debería volver a "Add to cart"
    add_button_selector = "[data-test^='add-to-cart-#{product_id}']"
    
    # Esperar a que aparezca el botón "Add to cart"
    begin
      button = find(add_button_selector, wait: 10)
      expect(button.text).to eq('Add to cart'), 
        "Expected button text to be 'Add to cart' but found '#{button.text}'"
    rescue Capybara::ElementNotFound
      # Si no encuentra el botón, algo está mal
      raise "No se encontró el botón 'Add to cart' para #{item_name}"
    end
  end

  def get_item_price(item_name)
    # Buscar el precio del producto
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