require 'capybara'

After('@quit') do
  Capybara.current_session.driver.quit
end

Before('@maximize') do
  page.driver.browser.manage.window.maximize
end

AfterStep('@slow') do
  sleep 1.5
end

AfterStep('@debug') do |result, step|
  puts "Step completed: #{step.text}"
end

After('@cart') do |scenario|
  puts "After hook ejecutándose para escenario: #{scenario.name}"
  
  if current_url.include?('inventory')
    if page.has_css?('[data-test^="remove-"]', wait: 2)
      puts "Limpiando carrito después del test..."
      all('[data-test^="remove-"]').each do |remove_button|
        remove_button.click
        sleep 0.3
      end
      sleep 0.5
    end
  end
end