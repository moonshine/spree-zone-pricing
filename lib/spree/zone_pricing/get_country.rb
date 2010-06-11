module Spree::ZonePricing::GetCountry
  def self.included(base)
    base.class_eval do
      # This method will retrieve the users country
      def get_user_country_id
        # Check if set in session
        country = session[:zone_pricing_country] if session.has_key?(:zone_pricing_country)
        # If no country in session, check if user has a bill address, if so use
        # the country from the address
        country ||= (current_user && current_user.respond_to?('ship_address') &&
          current_user.ship_address) ? current_user.ship_address.country.id : nil
        # If no bill address country use default country
        country ||= Spree::Config[:default_country_id]
      end
    end
  end
end