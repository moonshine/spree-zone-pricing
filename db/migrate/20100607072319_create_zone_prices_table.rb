class CreateZonePricesTable < ActiveRecord::Migration
  def self.up
    create_table :zone_prices do |t|
      t.references :variant
      t.references :zone
      t.decimal :price, :precision => 8, :scale => 2
      t.timestamps
    end
    add_index :zone_prices, :variant_id
    add_index :zone_prices, :zone_id
  end

  def self.down
    remove_index :zone_prices, :variant_id
    remove_index :zone_prices, :zone_id
    drop_table :zone_prices
  end
end