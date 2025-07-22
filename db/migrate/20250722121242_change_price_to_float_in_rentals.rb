class ChangePriceToFloatInRentals < ActiveRecord::Migration[7.1]
  def change
    change_column :rentals, :price, :float
  end
end
