class PlacesController < ApplicationController
	before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
	include HTTParty

	def index
		@places = Place
		.all
		.paginate(:page => params[:page], :per_page => 2)
	end

	def new
		@place = Place.new
	end

	def create
		@place = current_user.places.create(place_params)
		if @place.valid?
			redirect_to root_path
		else
			render :new, :status => :unprocessable_entity
		end
	end

	def show
		@place = Place.find(params[:id])
		@comment = Comment.new
		@photo = Photo.new
	end

	def edit
		@place = Place.find(params[:id])

		if @place.user != current_user
			return render :text => 'Not Allowed', :status => :forbidden
		end
	end

	def update
		@place = Place.find(params[:id])
		if @place.user != current_user
			return render :text => 'Not Allowed', :status => :forbidden
		end
		
		@place.update_attributes(place_params)
		if @place.valid?
			redirect_to root_path
		else
			render:edit, :status => :unprocessable_entity
		end
	end

	def destroy
		@place = Place.find(params[:id])
		if @place.user != current_user
			return render :text => 'Not Allowed', :status => :forbidden
		end
		@place.destroy
		redirect_to root_path
	end

	def google
		response = HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=tacos+in+Los+Angeles&maxprice=1&types=food&key=#{ENV["PLACES_API"]}")
		@token = response["next_page_token"]
		@google = response.parsed_response["results"]
		sleep 3
		@google2 = google2
	end

	def google2
			nextresponse = HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=tacos+in+Los+Angeles&maxprice=1&types=food&key=#{ENV["PLACES_API"]}&pagetoken=#{@token}")
			google = nextresponse.parsed_response["results"]
	end



	private

	def place_params
		params.require(:place).permit(:name, :description, :address)
	end

end
