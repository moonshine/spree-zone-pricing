= Zone Pricing

Description goes here

finds zone from default country for guests
set default via
Spree::Config.set(:default_country_id => Country.find_by_name("Australia"))

if no zone found or no zone price then variant/product price used
finds zone from bill address country for registered users
