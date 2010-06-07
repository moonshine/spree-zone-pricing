module Spree::SharedAssets::Admin::ImagesController

  def self.included(target)
    target.class_eval do

      destroy.wants.html { redirect_to admin_product_images_url(@product) }

      private

      def load_data
        @product = Product.find_by_permalink(params[:product_id])
      end

      def set_viewable
        # Check if "Product" option was selected
        if params[:image].has_key?(:shareable_id) && !params[:image][:shareable_id].blank?
          # Assign to product
          object.products << @product unless object.products.include?(@product)
          params[:image].delete(:shareable_id)
        else
          # "Product" option not selected

          # Check if at least one variant selected, if not assign to "Product"
          variant_ids = params[:image][:variant_ids].detect {|i| !i.blank?}
          unless variant_ids
            object.products << @product unless object.products.include?(@product)
          else
            # "Product" option not selected, delete if it exists
            shares = object.assets_shares.find_all_by_shareable_type('Product')
            shares.each{|s| s.destroy if s.shareable_id == @product.id} if shares.size > 0
          end
        end
      end

      def destroy_before
      end

    end
  end
  
end
