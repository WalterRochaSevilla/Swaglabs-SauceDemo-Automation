Before do |scenario|
  @scenario_variables = {}
  
  if scenario.respond_to?(:scenario_outline)
    scenario.name.scan(/<([^>]+)>/).flatten.each do |var_name|
      @scenario_variables[var_name] = nil 
    end
  end
end