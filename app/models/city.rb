class City < ApplicationRecord
  validates :external_id, :presence => true
  validates_uniqueness_of [:external_id, :name]

  def city_slug
    self.name.downcase.gsub(" ","")
  end
end
