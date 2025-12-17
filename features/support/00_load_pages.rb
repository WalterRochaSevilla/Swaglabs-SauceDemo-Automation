puts "Cargando Page Objects desde 00_load_pages.rb..."

# 1. Cargar la clase base primero para asegurar que esté definida.
require_relative '../pages/Form.rb'
# 2. Cargar todas las demás clases de Page Object que dependen de la base.
Dir[File.join(File.dirname(__FILE__), '../pages/*Page.rb')].sort.each { |file| require file }