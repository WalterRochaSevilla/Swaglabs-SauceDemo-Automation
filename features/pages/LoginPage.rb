require_relative 'Form'

class LoginPage < Form
  
  def visit_page
    visit '/'
  end

  def login_as(username, password)
    fill_in 'user-name', with: username
    fill_in 'password', with: password
    click_button 'login-button'
  end

  def click_login_button
    click_button 'login-button'
  end

  def logout_user
    click_button 'react-burger-menu-btn'
    find('#logout_sidebar_link', wait: 5).click
  end

  def verify_successful_login
    expect(page).to have_content('Products')
    expect(page).to have_css('.shopping_cart_link')
  end

  def verify_locked_out_message
    error_msg = find('[data-test="error"]').text
    expect(error_msg).to include('Sorry, this user has been locked out')
  end

  def verify_missing_credentials_error
    error_msg = find('[data-test="error"]').text
    expect(error_msg).to include('Username is required')
  end

  def verify_on_login_page
    expect(page).to have_selector('#login-button')
    expect(page).not_to have_css('.shopping_cart_link')
  end

  def verify_product_images_state(state)
    first_image = find('.inventory_item_img img', match: :first)
    src_attribute = first_image[:src]

    if state == "broken"
      expect(src_attribute).to include("sl-404")
    elsif state == "correct"
      expect(src_attribute).not_to include("sl-404")
      expect(src_attribute).to end_with(".jpg")
    end
  end

end