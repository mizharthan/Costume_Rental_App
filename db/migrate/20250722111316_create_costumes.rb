class CreateCostumes < ActiveRecord::Migration[7.1]
  def change
    create_table :costumes do |t|
      t.string :name
      t.integer :size
      t.string :description
      t.integer :price_per_day
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
