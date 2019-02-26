class CarCollection

	include Enumerable
	attr_accessor :cars

	def initialize(cars=[])
		self.cars = cars 
	end

	def each(&block)
		self.cars.each(&block)
	end

	def find(id)
    	a = self.select { |car| car.id === id }
    	a.first
  	end

end