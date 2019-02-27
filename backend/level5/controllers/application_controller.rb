require 'json'
require './models/car'
require './models/car_collection'
require './models/option'
require './models/options_collection'
require './models/rental'
require './models/rental_collection'
require './views/rentals'

class App
	
	include RentalView
	
	def initialize(input, output_path)
		begin
			if input = JSON.parse(File.read(input))
				@output_path = output_path
				@rental_collection = create(input)
			end
		rescue StandardError => msg
			msg
		end
	end

	def show
		export_as_json(@output_path, JSON.pretty_generate("rentals": JSON.parse(@rental_collection.to_json)))
	end

	private

	def create(input)
		cars = []
		input["cars"].map { |car| cars << Car.new(car) }
		car_collection = CarCollection.new(cars) 

		options = []
		input["options"].map { |option| options << Option.new(option) }
		options_collection = OptionsCollection.new(options)

		rentals = []
		input["rentals"].map do |rental| 
			car = car_collection.find_by_car(rental["car_id"])
			options = options_collection.find_by_rental(rental["id"])
			rentals << Rental.new(rental, car, options)
		end

		RentalCollection.new(rentals)

	end


end