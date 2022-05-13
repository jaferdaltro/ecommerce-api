module Admin::V1
  class ProductsController < ApiController
    before_action :load_product, only: %i(show update destroy)

    def index
      @products = load_products
    end

    def show; end

    def create
      run_service
    rescue Admin::ProductSavingService::NotSavedProductError
      render_error(fields: @saving_service.errors)
    end

    def update
      run_service
    rescue Admin::ProductSavingService::NotSavedProductError
      render_error(fields: @saving_service.errors)
    end

    def destroy
      @product.productable.destroy!
      @product.destroy!
    rescue ActiveRecord::RecordNotDestroyed
      render_error(fields: @product.errors.messages.merge(@product.productable.errors.messages))
    end

    private
    def load_product
      @product = Product.find(params[:id])
    end

    def load_products
      permitted = params.permit({ search: :name}, { order: {}}, :page, :length)
      Admin::ModelLoadingService.new(Product.all, permitted).call
    end

    def run_service(product = nil)
      @saving_service = Admin::ProductSavingService.new(product_params.to_h, @product).call
      @product = @saving_service.product
      render :show
    end

    def product_params
      return {} unless params.has_key?(:product)
      permited_params = params.require(:product).permit(:id, :name, :description, :price, :productable,
                                                         :image, :status, category_ids: [] )
      permited_params.merge(productable_params)
    end

    def productable_params
      productable_type = params[:product][:productable] || @product&.productable_type&.underscore
      return unless productable_type.present?
      productable_attributes = send("#{productable_type}_params")
      { productable_attributes: productable_attributes }
    end

    def game_params
      params.require(:product).permit(:mode, :release_at, :developer, :system_requirement_id)
    end
  end
end