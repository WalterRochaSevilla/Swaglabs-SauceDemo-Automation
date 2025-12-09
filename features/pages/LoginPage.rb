require_relative 'Form'

class LoginPage < Form
  
  LOGIN_SELECTORS = {
    "Username" => { "selector" => "user-name", "type" => "input" },
    "Password" => { "selector" => "password", "type" => "password" }
  }

  def visit_page
    visit '/'
  end

  def login_as(username, password)
    fill_in 'user-name', with: username
    fill_in 'password', with: password
    click_button 'login-button'
  end

  def verify_successful_login
    expect(page).to have_content('Products')
    expect(page).to have_css('.shopping_cart_link')
  end

  def verify_locked_out_message
    error_msg = find('[data-test="error"]').text
    expect(error_msg).to include('Sorry, this user has been locked out')
  end
end