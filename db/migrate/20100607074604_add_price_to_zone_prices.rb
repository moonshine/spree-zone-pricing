class AddPriceToZonePrices < ActiveRecord::Migration
  def self.up
    add_column :zone_prices, :price, :decimal, :null => true, :default => nil, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :zone_prices, :price
  end
end