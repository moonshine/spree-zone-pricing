# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ZonePricingExtension < Spree::Extension
  version "1.0"
  description "Allows prices to be set by zone"
  url "http://yourwebsite.com/zone_pricing"

  # Please use zone_pricing/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate

    # Add additional associations to allow m:m relationship
    # between zones<->products/variants
    Zone.send(:include, Spree::ZonePricing::Zone)
    Product.send(:include, Spree::ZonePricing::Zoneable)
    Variant.send(:include, Spree::ZonePricing::Zoneable)

    # Override controller methods
    #Admin::VariantsController.send(:include, Spree::SharedAssets::Admin::VariantsController)

  end
end
