class AddWearerToRentals < ActiveRecord::Migration[7.1]
  def change
    add_column :rentals, :wearer, :string
  end
end
