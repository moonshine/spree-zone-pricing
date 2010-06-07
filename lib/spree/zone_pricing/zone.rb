module Spree::ZonePricing::Zone

  def self.included(target)
    target.class_eval do
      has_many :zone_prices, :dependent => :destroy
      has_many :variants, :source => :zoneable, :through => :zone_prices, :source_type => "Variant", :class_name => "Variant"
      has_many :products, :source => :zoneable, :through => :zone_prices, :source_type => "Product", :class_name => "Product"
    end
  end
  
end
