class CitiesController < ApplicationController
  before_action :set_city, only: [:forecast]

  # GET /cities
  def index
    render json: { cities: City.all }
  end

  # POST /forecast
  def forecast
    if @city
      request = OpenWeather::Request.new(
                                          ENV["OPEN_WEATHER_API_KEY"],
                                          ENV.fetch("OPEN_WEATHER_LANG") { "pt_br" }
                                        )
      
      forecast = request.get_forecast(@city.external_id)
      weather = request.get(@city.external_id)
      tweet_content = weather_message(weather) + forecast_message(forecast)

      tweet = TwitterService.new.update(tweet_content)

      render json: { tweet: tweet_content, city: @city.name, forecast: forecast }
    elsif @cities.count > 0
      render json: { message: "There's more than one city with that name. Please specify city state or country.", cities: @cities.map{ |city| city.slice(:name, :state, :country) } }
    else
      render json: {}, status: :not_found
    end
  end

  private
    def set_city
      @cities = City.where('LOWER(name) LIKE LOWER(?)', "#{params[:city]}")

      if (params[:country] and params[:country].strip! != "")
        @cities = @cities.where({ country: params[:country] })
      end
      if (params[:state] and params[:state].strip! != "")
        @cities = @cities.where({ state: params[:state] })
      end

      if @cities.count == 1 
        @city = @cities.first
      end
    end

    # Only allow a list of trusted parameters through.
    def city_params
      params.permit(:city, :state, :country)
    end

    def weather_message(weather)
      date = I18n.l Date.today, :format => :short
      temp = format('%.1f', convert_kelvin_celsius(weather[:temp]))

      temp + "ºC em " + weather[:city] + " em " + date + '.'
    end

    def forecast_message(forecast)
      today = Date.today
      fc = forecast
        .filter { |f| f[:date].to_date != today }
        .group_by{ |f| f[:date].to_date }
        .map {
          |arr| 
            temps = arr[1].map { |f| f[:temp] }
            mean = temps.reduce(:+).to_f / temps.size
            temp = format('%.0f', convert_kelvin_celsius(mean)) + "ºC"

            temp + " em " + (I18n.l arr[0], :format => :short)
        }
      
      " Média para os próximos dias: " + fc.to_sentence + '.'
    end

    def convert_kelvin_celsius(k)
      k - 273.15
    end
end
