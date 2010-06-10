module Spree::ZonePricing::Zone

  def self.included(target)
    target.class_eval do
      has_many :zone_prices, :dependent => :destroy
      has_many :variants, :through => :zone_prices
    end
  end
  
end
