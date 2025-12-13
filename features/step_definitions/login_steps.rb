def login_page
  @login_page ||= LoginPage.new
end

Given('I am on the Sauce Demo Login Page') do
  login_page.visit_page
end

When('I attempt to login with user {string} and password {string}') do |user, password|
  login_page.login_as(user, password)
end

When('I click login without entering credentials') do
  login_page.click_login_button
end

When('I log out from the application') do
  login_page.logout_user
end

Then('I should be redirected to the Inventory Page') do
  login_page.verify_successful_login
end

Then('I should see a locked out error message') do
  login_page.verify_locked_out_message
end

Then('I should see a required field error') do
  login_page.verify_missing_credentials_error
end

Then('I should be returned to the Login Page') do
  login_page.verify_on_login_page
end

Then('I should see {string} product images') do |state|
  login_page.verify_product_images_state(state)
end