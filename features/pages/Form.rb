require 'capybara/dsl'
require 'rspec/expectations'

class Form
  include Capybara::DSL
  include RSpec::Matchers

  def fill_in_fields(table, fields_mapping)
    table.raw.each do |row|
      field_name, value = row
      
      if fields_mapping.has_key?(field_name)
        config = fields_mapping[field_name]
        selector = config["selector"]
        type = config["type"]

        case type
        when "input"
          fill_in selector, with: value
        when "password"
          fill_in selector, with: value
        when "select"
          select value, from: selector
        when "checkbox"
          value.to_s.downcase == 'true' ? check(selector) : uncheck(selector)
        end
      end
    end
  end

  def clean_currency_format(text)
    text.gsub(/[\$,]/, '').to_f
  end

  def verify_current_url(partial_url)
    expect(current_url).to include(partial_url)
  end
end