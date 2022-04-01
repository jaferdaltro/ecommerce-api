module Admin::V1
  class CategoriesController < ApiController
    before_action :set_category, only: %i(update destroy)

    def index
      @categories = load_categories
    end

    def create
      @category = Category.new
      @category.attributes = category_params
      save_category
    end

    def update
      @category.attributes = category_params
     save_category
    end

    def destroy
      @category.destroy!
    rescue
      render_errors(fields: @category.errors.messages)
    end
    private

    def load_categories
      permitted = params.permit( { search: :name }, { order: {} }, :page, :length )
      Admin::ModelLoadingService.new(Category.all, permitted).call
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def save_category
      @category.save!
      render :show
    rescue
      render_error(fields: @category.errors.messages)
    end

    def category_params
      return {} unless params.has_key?(:category)
      params.require(:category).permit(:id, :name)
    end
  end
end
