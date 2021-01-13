# Tish's Weather Twitter API

This is a REST API with only two endpoints.

The only model is the City one, so is the only controller.

The main point of this application is to tweet the weekly forecast from OpenWeather for the city name sent in the request to a twitter account. In this case, mine ((@tishcode)[http://twitter.com/tishcode]). The available endpoint is http://tish-weather-twitter.herokuapp.com/api/, but please don't spam it.

The application is loaded with all available city names from Brazil and United States and it behaves a little different from the original OpenWeather API when a duplicated name is given. Spoilers! Hope you like it!

Clone the project and follow the instructions below :)

## Install

    sh scripts/install.sh

## Run the app

    docker-compose up app

## Run the tests

    docker-compose run -e RAILS_ENV=test --rm app rails test

# REST API

## Get list of Cities

### Request

`GET /cities/`

```bash
    curl -i -H 'Accept: application/json' http://localhost:3000/api/cities/
```

### Response

    HTTP/1.1 200 OK
    Status: 200 OK
    Content-Type: application/json; charset=utf-8

```json
    {
      "cities": [{
        "id": 1,
        "name": "Zumbi",
        "state": "",
        "country": "BR",
        "external_id": 3384868,
        "created_at": "2021-01-09T22:24:30.584Z",
        "updated_at": "2021-01-09T22:24:30.584Z"
        }, ...
      ]
    }
```

## Tweet a City forecast

### Request

`POST /forecast/`

```bash
    curl -i -H 'Content-Type: application/json' -d '{"city": "Curitiba"}' http://localhost:3000/api/forecast
```
### Response

    HTTP/1.1 200 OK
    Status: 200 OK
    Content-Type: application/json; charset=utf-8

```json
    {
      "tweet": "20.2ºC em Curitiba em 13/01. Média para os próximos dias: 21ºC em 14/01, 21ºC em 15/01, 22ºC em 16/01, 21ºC em 17/01 e 22ºC em 18/01.",
      "city": "Curitiba",
      "forecast": [
        {
          "temp": 292.91,
          "date": "2021-01-14 00:00:00",
          "weather": [{
            "main": "Clouds",
            "description": "nublado"
          }]
        }, ...
      ]
    }
```


## Tweet a City forecast when City name is not unique

### Request

`POST /forecast/`

```bash
    curl -i -H 'Content-Type: application/json' -d '{"city": "Las Vegas", "state": "NV", "country": "US"}' http://localhost:3000/api/forecast
```
### Response

    HTTP/1.1 200 OK
    Status: 200 OK
    Content-Type: application/json; charset=utf-8

```json
    {
      "tweet": "15.6ºC em Las Vegas em 13/01. Média para os próximos dias: 12ºC em 14/01, 13ºC em 15/01, 13ºC em 16/01, 12ºC em 17/01 e 12ºC em 18/01.",
      "city": "Las Vegas",
      "forecast": [
        {
          "temp": 288.72,
          "date": "2021-01-14 00:00:00",
          "weather": [{
            "main": "Clouds",
            "description": "nuvens dispersas"
          }]
        }, ...
      ]
    }
```

