class LoginPage < Form
  # Usar selectores por data-test que son más estables
  USERNAME_FIELD = '[data-test="username"]'
  PASSWORD_FIELD = '[data-test="password"]'
  LOGIN_BUTTON = '[data-test="login-button"]'

  def visit_page
    puts "DEBUG: Visitando página de login..."
    visit('/')
    # Use an explicit wait to ensure the page is ready
    expect(page).to have_selector(USERNAME_FIELD, wait: 10)
    puts "DEBUG: Página visitada - URL actual: #{current_url}"
  end

  def login_with_credentials(username, password)
    puts "DEBUG: Intentando login con usuario: #{username}"
    
    # Intentar múltiples formas de encontrar los campos
    begin
      # Método 1: Por data-test (preferido)
      find(USERNAME_FIELD, wait: 10).set(username)
      find(PASSWORD_FIELD, wait: 10).set(password)
      find(LOGIN_BUTTON, wait: 10).click
    rescue Capybara::ElementNotFound
      puts "DEBUG: Método 1 falló, intentando método 2..."
      
      # Método 2: Por id
      fill_in 'user-name', with: username
      fill_in 'password', with: password
      click_button 'Login'
    rescue Capybara::ElementNotFound => e
      puts "ERROR: No se pudo encontrar elementos de login"
      puts "HTML de la página (primeros 1000 caracteres):"
      puts page.html[0..1000]
      raise e
    end
    
    puts "DEBUG: Login completado"
    
    # Explicitly wait for an element on the next page to ensure login was successful
    expect(page).to have_selector('.inventory_list', wait: 10)
  end
end