class City < ApplicationRecord
  validates :external_id, :presence => true
  validates :name, :presence => true

  validates_uniqueness_of :external_id
  validates_uniqueness_of :name, scope: [:state, :country]

  def city_slug
    self.name.downcase.gsub(" ","")
  end
end
