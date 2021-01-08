require 'json'

file = File.read("city.list.json")
json = JSON.parse(file)
cities = []

json.each do |city|
  puts city["name"]
  cities.push({ name: city["name"], external_id: city["id"] })
end

City.create(cities)
