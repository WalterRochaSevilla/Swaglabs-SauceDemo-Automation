def login_page
  @login_page ||= LoginPage.new
end

Given('I am on the Sauce Demo Login Page') do
  # Logic: Navigates to the base URL defined in env.rb
  login_page.visit_page
end

When('I attempt to login with user {string} and password {string}') do |user, password|
  # Logic: generic step handling dynamic data from Examples table or single Scenario
  login_page.login_as(user, password)
end

Then('I should be redirected to the Inventory Page') do
  # Logic: Verifies successful transition by checking for unique Inventory elements
  login_page.verify_successful_login
end

Then('I should see a locked out error message') do
  # Logic: Verifies specific error text in the DOM for negative testing
  login_page.verify_locked_out_message
end