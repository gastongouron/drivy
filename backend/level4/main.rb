# Run tests with $ruby tests/specs.rb

require './controllers/application_controller'

input = './data/input.json'
output = './data/output.json'

App.new(input, output).show