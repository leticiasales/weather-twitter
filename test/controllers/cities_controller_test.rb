require "test_helper"

class CitiesControllerTest < ActionDispatch::IntegrationTest
  test "tweet city weather and forecast" do
    city = cities(:curitiba)

    post forecast_url({ city: city.name })

    forecast = JSON.parse(@response.body)

    assert_equal city.name, forecast["city"]
    assert_response 200
  end

  test "getting forecast for duplicated city" do
    city = cities(:lasvegasNV)
    cities = City.where(name: city.name)
                 .map { |city| city.slice(:name, :state, :country) }
              
    post forecast_url({ city: city.name })

    forecast = JSON.parse(@response.body)

    assert_match "There's more than one city with that name.", forecast["message"]
    assert_equal cities, forecast["cities"]
    assert_response 200
  end

  test "getting forecast for city with wrong country" do
    city = cities(:newyork)

    post forecast_url({ city: city.name, country: "BR" })

    forecast = JSON.parse(@response.body)

    assert_equal "{}", forecast.to_s
    assert_response 200
  end

  test "getting forecast for non-existent city" do
    post forecast_url({ city: "Wonderland" })

    forecast = JSON.parse(@response.body)

    assert_equal "{}", forecast.to_s
    assert_response 200
  end
end
