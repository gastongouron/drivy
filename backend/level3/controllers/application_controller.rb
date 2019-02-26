require 'json'
require './models/car'
require './models/car_collection'
require './models/rental'
require './models/rental_collection'
require './views/rentals'

class App

	def initialize(input, output_path)
		begin
			if input = JSON.parse(File.read(input))
				@output_path = output_path
				@rental_collection = create_rentals(input)
			end
		rescue StandardError => msg
			msg
		end
	end

	def show
		RentalView.new(@output_path, JSON.pretty_generate("rentals": JSON.parse(@rental_collection.to_json)))
	end

	private

	def create_rentals(input)
		cars = []
		input["cars"].map { |car| cars << Car.new(car) }
		car_collection = CarCollection.new(cars) 

		rentals = []
		input["rentals"].map { |rental| rentals << Rental.new(rental, car_collection.find(rental["car_id"]))}
		RentalCollection.new(rentals)
	end


end