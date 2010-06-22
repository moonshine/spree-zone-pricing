module Spree::ZonePricing::OrdersController
  def self.included(target)
    target.class_eval do
      alias_method :spree_create_before, :create_before unless method_defined?(:spree_create_before)
      alias_method :create_before, :site_create_before
    end
  end

  # The order object needs to know which country has been selected
  # by the user so that we can calculate the zone prices. This informations
  # may be stored in the session which we do not have access to in the model
  # so this method will get the currently selected country and provide it to
  # the Order model
  def site_create_before
    @order.country_id = get_user_country_id if @order
    spree_create_before
  end

end
