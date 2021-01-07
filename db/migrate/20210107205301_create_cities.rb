class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.text :name
      t.integer :external_id

      t.timestamps
    end
  end
end
