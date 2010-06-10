class ZonePricingHooks < Spree::ThemeSupport::HookListener

  # Add zone pricing tab to products admin area
  insert_after :admin_product_tabs, :partial => "admin/shared/zp_product_tab"

end
