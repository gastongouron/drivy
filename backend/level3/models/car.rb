class Car
	attr_reader :id, :price_per_day, :price_per_km

	def initialize(car_obj)
		@id 			= car_obj["id"]
		@price_per_day 	= car_obj["price_per_day"]
		@price_per_km 	= car_obj["price_per_km"]
	end

end