require_relative 'Form'

class CheckoutPage < Form
  FIRST_NAME_FIELD = '#first-name'
  LAST_NAME_FIELD = '#last-name'
  POSTAL_CODE_FIELD = '#postal-code'
  CONTINUE_BUTTON = '#continue'
  FINISH_BUTTON = '#finish'
  ERROR_MESSAGE_CONTAINER = '[data-test="error"]'
  SUBTOTAL_LABEL = '.summary_subtotal_label'
  TAX_LABEL = '.summary_tax_label'
  TOTAL_LABEL = '.summary_total_label'

  def fill_checkout_information(first_name, last_name, postal_code)
    expect(page).to have_selector(FIRST_NAME_FIELD, wait: 10)    
    find(FIRST_NAME_FIELD).set(first_name)
    find(LAST_NAME_FIELD).set(last_name)
    find(POSTAL_CODE_FIELD).set(postal_code)    
    find(CONTINUE_BUTTON).click
  end

  def verify_checkout_error_message(expected_message)
    error_element = find(ERROR_MESSAGE_CONTAINER, wait: 5)
    expect(error_element.text).to include(expected_message)
  end

  def validate_financials(tax_rate)
    expect(page).to have_current_path(/\/checkout-step-two\.html/, wait: 10)
    subtotal_text = find(SUBTOTAL_LABEL).text
    subtotal_from_ui = clean_currency_format(subtotal_text)
    expect(subtotal_from_ui).to be > 0
    expected_tax = (subtotal_from_ui * tax_rate).round(2)
    expected_total = (subtotal_from_ui + expected_tax).round(2)
    tax_text = find(TAX_LABEL).text
    tax_from_ui = clean_currency_format(tax_text)
    total_text = find(TOTAL_LABEL).text
    total_from_ui = clean_currency_format(total_text)
    expect(tax_from_ui).to be_within(0.01).of(expected_tax)
    expect(total_from_ui).to be_within(0.01).of(expected_total)
  end

  def finish_purchase
    find(FINISH_BUTTON).click
  end
end