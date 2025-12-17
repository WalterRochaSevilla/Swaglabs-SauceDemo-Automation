class InventoryPage < Form
  ADD_TO_CART_BUTTON = '.btn_inventory'
  CART_BADGE = '.shopping_cart_badge'

  def add_first_n_products_to_cart(count)
    # Explicitly use page.all to avoid conflict with RSpec::Matchers.all
    page.all(ADD_TO_CART_BUTTON).first(count).each(&:click)
    # Verify that the action was successful by waiting for the badge to appear
    expect(page).to have_selector(CART_BADGE, text: count.to_s, wait: 5)
  end

  def navigate_to_cart
    find(CART_BADGE).click
  end
end
