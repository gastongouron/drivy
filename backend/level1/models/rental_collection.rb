class RentalCollection

	include Enumerable
	attr_accessor :rentals

	def initialize(rentals=[])
		self.rentals = rentals 
	end

	def each(&block)
		self.rentals.each(&block)
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


end