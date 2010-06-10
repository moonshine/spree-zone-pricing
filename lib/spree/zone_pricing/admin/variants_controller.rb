module Spree::ZonePricing::Admin::VariantsController

  def self.included(target)
    target.class_eval do

      create.before do
        # Set zone product to default if they exist
        object.set_default_zone_prices(get_user_country_id)
        # Make sure to call original code to save
        create_before
      end

      update.response do |wants|
        wants.html do
          redirect_to object.is_master ? zone_prices_admin_product_variant_url(object.product, object) : collection_url
        end
      end

      def object
       @object ||= Variant.find(params[:id])
      end

      def zone_prices
        @variant = object
        @product = @variant.product
      end
    end
  end
  
end
