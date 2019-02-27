module RentalView
  def export_as_json(file_path, data)
	File.open(file_path, 'w') do |output|
		output.puts data
	end
  end
end
