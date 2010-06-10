module Spree::ZonePricing::GetCountry
  def self.included(base)
    base.class_eval do
      # This method will retrieve the users country
      def get_user_country_id
        # Check if set in session
        country = session[:country] if session.has_key?(:country)
        # If no country in session, check if user has a bill address, if so use
        # the country from the address
        country ||= (current_user && current_user.respond_to?('bill_address') &&
          current_user.bill_address) ? current_user.bill_address.country.id : nil
        # If no bill address country use default country
        country ||= Spree::Config[:default_country_id]
      end
    end
  end
end