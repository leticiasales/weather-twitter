require 'json'

file = File.read(ENV.fetch("SEED_FILE") { "city.list.json" })
json = JSON.parse(file)

json.each do |city|
  puts city["name"]
  City.create({ name: city["name"], external_id: city["id"] })
end
