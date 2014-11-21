namespace :data do
  def import_place(place)
  	Place.create(
  		:name => place["name"],
  		:address => place["formatted_address"],
  		:description => "Imported by google"
	)
  end


  desc "TODO"
  task import: :environment do


		response = HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=tacos+in+Los+Angeles&maxprice=1&types=food&key=#{ENV["PLACES_API"]}")
		@token = response["next_page_token"]
		@google = response.parsed_response["results"]
		

		@google.each do |place|
			import_place(place)
			
		end
			
		if !@token.nil?	
			puts "THIS IS PAGE 2 ...."

			sleep 4
			nextresponse = HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=tacos+in+Los+Angeles&maxprice=1&types=food&key=#{ENV["PLACES_API"]}&pagetoken=#{@token}")
			@google = nextresponse.parsed_response["results"]
		

			@google.each do |place|
				import_place(place)
				
			end
		end


  end

end
