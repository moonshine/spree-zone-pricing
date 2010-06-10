module Spree::ZonePricing::Variant

  def self.included(target)
    target.class_eval do
      has_many :zone_prices, :dependent => :destroy
      has_many :zones, :through => :zone_prices

      # Update zone prices for variant from attributes
      # passed to us from the form
      def zone_price_attributes=(price_attributes)
        price_attributes.each do |key, value|
          # Check if record exists, if so update. If value of price
          # is blank or 0 then delete record
          zone_price = ZonePrice.first(:conditions => {:zone_id => key, :variant_id => self.id})
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

      # Return zone price if defined otherwise return normal price
      def zone_price(country_id)
        # Find zone and check if zone price set for the product/variant
        zone = Country.find(country_id).zone
        zone_price = self.zone_prices.find_by_zone_id(zone.id) if zone && self.respond_to?('zone_prices')
        if zone_price
          # Zone price set us it
          amount = zone_price.price
        else
          amount = self.price
        end
      end

      # Method to default variant zone prices to the product zone prices
      def set_default_zone_prices(country_id)
        return if self.product.master.zone_prices.size <= 0 # No zone prices specified for product
        # Assign product zone prices as defaults
        self.product.master.zone_prices.each {|zp| self.zone_prices.build(zp.attributes)}
      end

    end
  end

end
