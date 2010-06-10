map.namespace :admin do |admin|
   admin.resources :products do |product|
     product.resources :variants, :member => {:zone_prices => :get}
   end
end