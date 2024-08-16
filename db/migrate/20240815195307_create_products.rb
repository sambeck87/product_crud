class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :sku
      t.boolean :is_seasonal
      t.decimal :quantity
      t.integer :measurement_unit
      t.integer :category

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :name, unique: true
  end
end
