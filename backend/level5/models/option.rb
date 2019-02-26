class Option
	attr_reader :id, :rental_id, :type

	def initialize(option_obj)
		@id 		= option_obj["id"]
		@rental_id 	= option_obj["rental_id"]
		@type 		= option_obj["type"]
	end

end