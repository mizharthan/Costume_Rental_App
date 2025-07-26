class AddCategoryToCostumes < ActiveRecord::Migration[7.1]
  def change
    add_column :costumes, :category, :string
  end
end
