require 'date'

class Rental

	def initialize(rental_obj, car, options)
		@id 		= rental_obj["id"]
		@start_date = rental_obj["start_date"]
		@end_date 	= rental_obj["end_date"]
		@distance 	= rental_obj["distance"]
		@options 	= options
		@car 		= car
		@car_ppd 	= get_car_ppd
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
		ppd = @car_ppd	
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

	def get_car_ppd
		options = get_options
		if options != []

			options_stack = []
			options.each do |option|

				case option
					when "gps"
						options_stack << 500
					when "baby_seat"
						options_stack << 200
					when "additional_insurance"
						options_stack << 1000
					else
						return
				end
			end
			@car.price_per_day + options_stack.reduce(:+)
		else
			@car.price_per_day
		end



	end

	def get_actions
		actions = []
		["driver", "owner", "insurence", "assistance", "drivy"].each do |actor|
			who = actor
			type = actor == "driver" ? "debit" : "credit"
			amount = actor == "driver" ? @price : get_credit_amount(actor)
			actions << {"who": who, type: type, amount: amount}
		end
		actions
	end

	def get_options
		options = []
		@options.each do |option|
			options << option.type
		end
		options
	end

	def get_credit_amount(actor)
		duration = get_duration
		total_comission = (@price * 30) / 100
		insurence = total_comission / 2
		assistance = duration * 100
		drivy = total_comission - insurence - assistance

		case actor
			when 'owner'
				@price - total_comission
			when 'insurence'
				insurence
			when 'assistance'
				assistance
			else 				
				drivy
		end
	end

	def as_json(options={})
		{
			id: @id,
			options: get_options,
			actions: get_actions
		}
	end

end