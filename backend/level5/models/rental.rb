require 'date'

class Rental

	def initialize(rental_obj, car, options)
		@id 		= rental_obj["id"]
		@start_date = rental_obj["start_date"]
		@end_date 	= rental_obj["end_date"]
		@distance 	= rental_obj["distance"]
		@options 	= options
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
		@car.price_per_day	
		i = 0
		day_stack = []
		while duration > i
			case i
				when 0
					day_stack << @car.price_per_day
				when 1..3
					day_stack << @car.price_per_day - (@car.price_per_day*10) / 100
				when 4..9
					day_stack << @car.price_per_day - (@car.price_per_day*30) / 100
				else 				
					day_stack << @car.price_per_day - (@car.price_per_day*50) / 100
			end
			i += 1
		end
		sum_val_of(day_stack)
	end

	def get_actions
		actions = []
		["driver", "owner", "insurance", "assistance", "drivy"].each do |actor|
			who 	= actor
			type 	= actor == "driver" ? "debit" : "credit"
			amount 	= get_credit_amount(actor)
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
		options 	= get_options
		duration 	= get_duration
		comission 	= (@price * 30) / 100
		insurance 	= comission / 2
		assistance 	= duration * 100
		drivy 		= comission - insurance - assistance

		case actor
			when 'driver'
				@price + get_options_price_if_options?(options, duration, 'driver')
			when 'owner'
				price = (@price - comission) + get_options_price_if_options?(options, duration, 'owner')
			when 'insurance'
				insurance
			when 'assistance'
				assistance
			when 'drivy'
				drivy + get_options_price_if_options?(options, duration, 'drivy')
			else
				return
		end
	end

	def as_json(options={})
		{
			id: @id,
			options: get_options,
			actions: get_actions
		}
	end

	def sum_val_of(array)
		array.reduce(:+)
	end

	def get_options_price_if_options?(options, duration, actor)
		options_stack = []

		unless actor === 'drivy'
			options.include?('gps') ? options_stack.push(500*duration) : options_stack
			options.include?('baby_seat') ? options_stack.push(200*duration) : options_stack
		end

		(actor === 'driver' || actor === 'drivy') && options.include?('additional_insurance') ? options_stack.push(1000*duration) : options_stack.push(0)

		sum_val_of(options_stack)

	end

end