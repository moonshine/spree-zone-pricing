module Spree::ZonePricing::CheckoutsController
  def self.included(target)
    target.class_eval do
      address.update_hook :update_zone_prices
    end
  end

  private

  # Check the ship country and compare against the currently selected country,
  # if different update the order line items with the prices from the ship country
  def update_zone_prices
    # Same country do not update prices
    return if get_user_country_id == object.ship_address.country.id 
    # Update the order prices using the ship to country
    @order.update_zone_prices(object.ship_address.country.id)
    # Update selected country with ship to country
    session[:zone_pricing_country] = object.ship_address.country.id
  end

end
