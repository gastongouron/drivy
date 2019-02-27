class OptionsCollection

	include Enumerable
	attr_accessor :options

	def initialize(options=[])
		self.options = options 
	end

	def find_by_rental(rental_id)
    	a = self.select { |option| option.rental_id === rental_id }
  	end

	def to_json(*options)
		as_json(*options).to_json(*options)
	end

  	private

	def as_json(options={}, &block)
		each do |el|
			el
		end
	end

	def each(&block)
		self.options.each(&block)
	end


end