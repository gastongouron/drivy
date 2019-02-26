class RentalView

	def initialize(file_path, data)
		File.open(file_path, 'w') do |output|
			output.puts data
		end
	end

end