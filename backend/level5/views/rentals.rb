module RentalView
  def log(file_path, data)
	File.open(file_path, 'w') do |output|
		output.puts data
	end
  end
end
