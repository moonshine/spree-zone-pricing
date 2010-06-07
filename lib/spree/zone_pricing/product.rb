module Spree::ZonePricing::Product

  def self.included(target)
    target.class_eval do
      has_many :zone_prices, :dependent => :destroy, :as => :zoneable
      has_many :zones, :through => :zone_prices
    end
  end
  
end
