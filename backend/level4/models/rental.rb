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


	def get_actions
		actions = []
		["driver", "owner", "insurence", "assistance", "drivy"].each do |actor|
			who = actor
			type = actor == "driver" ? "debit" : "credit"
			amount = actor == "driver" ? @price : get_credit_amount(actor)
			actions.push({"who": who, type: type, amount: amount}) 
		end
		actions
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
			actions: get_actions
		}
	end

end