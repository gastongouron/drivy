require 'json'
require_relative '../controllers/application_controller'
require "minitest/autorun"

describe App do
  before do
    @app = App.new('./data/input.json', "./data/output.json").show
  end

  describe "Respects business logic by" do
    it "having the same output as expected one" do
      JSON.parse(File.read('./data/output.json')).must_equal(JSON.parse(File.read('./data/expected_output.json')))
     end
  end
end

