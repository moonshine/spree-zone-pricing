module Spree::ZonePricing::Admin::VariantsController

  def self.included(target)
    target.class_eval do

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
