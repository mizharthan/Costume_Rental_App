class ChangeStatusToIntegerInRentals < ActiveRecord::Migration[7.1]
  def change
    remove_column :rentals, :status, :string
    add_column :rentals, :status, :integer, default: 0, null:false
  end
end
