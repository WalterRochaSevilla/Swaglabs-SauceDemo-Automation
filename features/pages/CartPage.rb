require_relative 'Form'

class CartPage < Form
  CHECKOUT_BUTTON = '#checkout'

  def proceed_to_checkout
    find(CHECKOUT_BUTTON).click
  end
end