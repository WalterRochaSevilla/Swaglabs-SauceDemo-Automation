begin 
  require 'rspec/expectations'
rescue LoadError
  require 'spec/expectations'
end

require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--start-maximized')
  options.add_argument('--start-maximized')
  options.add_argument('--incognito')
  options.add_argument('--disable-notifications')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--allow-running-insecure-content')
  options.add_argument('--disable-web-security')
  options.add_argument('--no-proxy-server')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.configure do |config|
  config.default_driver = :chrome
  config.app_host = "https://www.saucedemo.com"
  config.default_max_wait_time = 30
  config.run_server = false
end

World(Capybara::DSL)