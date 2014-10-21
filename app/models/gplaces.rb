class GPlaces
	include HTTParty

def fetch_places
	HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=tacos+in+Los+Angeles&maxprice=1&types=food&key=#{ENV["PLACES_API"]}")






end
