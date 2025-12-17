require_relative 'Form'

class InventoryPage < Form
  ADD_TO_CART_BUTTON = '.btn_inventory'
  CART_BADGE = '.shopping_cart_badge'

  def add_first_n_products_to_cart(count)
    expect(page).to have_selector(ADD_TO_CART_BUTTON, wait: 10)
    page.all(ADD_TO_CART_BUTTON).first(count).each(&:click)
    expect(page).to have_selector(CART_BADGE, text: count.to_s, wait: 5)
  end

  def navigate_to_cart
    find(CART_BADGE).click
  end
end