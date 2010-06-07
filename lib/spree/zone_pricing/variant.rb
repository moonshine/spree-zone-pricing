module Spree::ZonePricing::Variant

  def self.included(target)
    target.class_eval do
      has_many :zone_prices, :dependent => :destroy, :as => :zoneable
      has_many :zones, :through => :zone_prices

      # Update zone prices for variant from attributes
      # passed to us from the form
      def zone_prices_attributes=(price_attributes)
        price_attributes.each do |key, value|
          # Check if record exists, if so update. If value of price
          # is blank or 0 then delete record
          zone_price = ZonePrice.find(key, self.id)
          if zone_price
            # Record exists, update or delete if no price specified
            if value['price'].to_f != 0
              zone_price.update_attribute(:price, value['price'].to_f)
            else
              zone_price.destroy
            end
          elsif value['price'].to_f != 0
            # Record does not exist, create
            ZonePrice.create(:zone_id => key, :variant => self, :price => value['price'].to_f)
          end
        end
      end
    end
  end

end
