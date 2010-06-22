module Spree::ZonePricing::Order

  def self.included(target)
    target.class_eval do
      # Override add_variant method so that we can use zone pricing
      alias :spree_add_variant :add_variant unless method_defined?(:spree_add_variant)
      alias :add_variant :site_add_variant

      # Method to update prices in the current order when country changes
      def update_zone_prices(country_id); order_update_zone_prices(country_id); end

      # We need to know what the currently selected country is so that we can
      # determine the zone price
      attr_accessor :country_id
    end
  end

  # Override the add_variant functionality so that we can adjust the price based on
  # the country and therefore zone selected
  def site_add_variant(variant, quantity=1)
    current_item = contains?(variant)
    # Added: Check if country specified, if so check if zone price defined,
    # if no country specified use normal price
    if @country_id
      price = variant.zone_price(@country_id)
    else
      price = variant.price
    end
    if current_item
      current_item.increment_quantity unless quantity > 1
      current_item.quantity = (current_item.quantity + quantity) if quantity > 1
      current_item.price = price # Added
      current_item.save
    else
      current_item = LineItem.new(:quantity => quantity)
      current_item.variant = variant
      current_item.price   = price
      self.line_items << current_item
    end

    # populate line_items attributes for additional_fields entries
    # that have populate => [:line_item]
    Variant.additional_fields.select{|f| !f[:populate].nil? && f[:populate].include?(:line_item) }.each do |field|
      value = ""

      if field[:only].nil? || field[:only].include?(:variant)
        value = variant.send(field[:name].gsub(" ", "_").downcase)
      elsif field[:only].include?(:product)
        value = variant.product.send(field[:name].gsub(" ", "_").downcase)
      end
      current_item.update_attribute(field[:name].gsub(" ", "_").downcase, value)
    end

    current_item
  end

  private

  # Update price of line items in current order on change
  # of country
  def order_update_zone_prices(country_id)
    self.line_items.each {|li| li.update_attribute(:price, li.variant.zone_price(country_id))}
    update_totals!
  end
end
