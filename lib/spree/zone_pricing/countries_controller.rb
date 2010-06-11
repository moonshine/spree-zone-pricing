module Spree::ZonePricing::CountriesController

  def self.included(target)
    target.class_eval do

      # Change the currently selected country
      def set
        country = Country.find(params[:id])
        if request.referer && request.referer.starts_with?("http://" + request.host)
          session[:return_to] = request.referer
        end
        if country
          # Store country in the session
          session[:country] = country.id
          # Update prices for the current order
          if session[:order_id]
            order = Order.find(session[:order_id])
            order.update_zone_prices(get_user_country_id)
          end
          flash[:notice] = t("country_changed")
        else
          flash[:error] = t("country_not_changed")
        end
        redirect_back_or_default(root_path)
      end

    end
  end
  
end
