class ChangePricePerDayToFloatInCostumes < ActiveRecord::Migration[7.1]
  def change
    change_column :costumes, :price_per_day, :float
  end
end
