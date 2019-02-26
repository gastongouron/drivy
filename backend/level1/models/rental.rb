require 'date'

class Rental

	def initialize(rental_obj, car)
		@id 		= rental_obj["id"]
		@start_date = rental_obj["start_date"]
		@end_date 	= rental_obj["end_date"]
		@distance 	= rental_obj["distance"]
		@car 		= car
		@price 		= set_price
	end

	def to_json(*options)
		as_json(*options).to_json(*options)
	end

	private

	def set_price
		get_price_for_distance + get_price_for_duration
	end

	def get_price_for_distance
		@distance * @car.price_per_km
	end

	def get_price_for_duration
		get_duration * @car.price_per_day
	end

	def get_duration
		(Date.parse(@start_date)..Date.parse(@end_date)).count
	end

	def as_json(options={})
		{
			id: @id,
			price: @price
		}
	end

end