class City < ApplicationRecord

  def city_slug
    self.name.downcase.gsub(" ","")
  end
end
