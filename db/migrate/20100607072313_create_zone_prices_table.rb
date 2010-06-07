class CreateZonePricesTable < ActiveRecord::Migration
  def self.up
    create_table :zone_prices do |t|
      t.references :zoneable, :polymorphic => true
      t.references :zone
    end
    add_index :zone_prices, :zoneable_id
    add_index :zone_prices, :zoneable_type
  end

  def self.down
    remove_index :zone_prices, :zoneable_id
    remove_index :zone_prices, :zoneable_type
    drop_table :zone_prices
  end
end