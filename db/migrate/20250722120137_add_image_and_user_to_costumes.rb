class AddImageAndUserToCostumes < ActiveRecord::Migration[7.1]
  def change
    add_column :costumes, :image, :string
  end
end
