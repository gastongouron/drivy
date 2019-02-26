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
		apply_offer_if_required!
	end

	def get_duration
		(Date.parse(@start_date)..Date.parse(@end_date)).count
	end

	def apply_offer_if_required!
		duration = get_duration
		ppd = @car.price_per_day	
		i = 0
		day_stack = []

		while duration > i
			case i
				when 0
					day_stack << ppd
				when 1..3
					day_stack << ppd - (ppd*10) / 100
				when 4..9
					day_stack << ppd - (ppd*30) / 100
				else 				
					day_stack << ppd - (ppd*50) / 100
			end
			i += 1
		end
		day_stack.reduce(:+)
	end

	def as_json(options={})
		{
			id: @id,
			price: @price
		}
	end

end