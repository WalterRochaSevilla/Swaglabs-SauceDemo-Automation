def login_page
  @login_page ||= LoginPage.new
end

Given('I navigate to the Sauce Demo Login Page') do
  login_page.visit_page
end

When('I attempt to login with user {string} and password {string}') do |username, password|
  login_page.login_with_credentials(username, password)
end