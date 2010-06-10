module Spree::ZonePricing::ProductsHelper
  def self.included(base)
    base.class_eval do
      alias_method :spree_product_price, :product_price unless method_defined?(:spree_product_price)
      alias_method :product_price, :site_product_price
    end
  end

  private

  # returns the price of the product to show for display purposes
  def site_product_price(product_or_variant, options={})
    options.assert_valid_keys(:format_as_currency, :show_vat_text)
    options.reverse_merge! :format_as_currency => true, :show_vat_text => Spree::Config[:show_price_inc_vat]

    # Check if this object is a product, if so then access the master variant
    # record for the product to get the zone pricing
    object = product_or_variant.is_a?(Product) ? product_or_variant.master : product_or_variant

    # Get the zone price for this variant/product if one is defined
    # otherwise use the normal price
    if object.respond_to?(:zone_price)
      amount = object.zone_price(get_user_country_id)
    else
      amount = object.price
    end

    amount += Calculator::Vat.calculate_tax_on(product_or_variant) if Spree::Config[:show_price_inc_vat]
    options.delete(:format_as_currency) ? format_price(amount, options) : ("%0.2f" % amount).to_f
  end

end