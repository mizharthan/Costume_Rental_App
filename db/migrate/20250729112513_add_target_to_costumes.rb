class AddTargetToCostumes < ActiveRecord::Migration[7.1]
  def change
    add_column :costumes, :wearer, :string
  end
end
