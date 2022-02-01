module Admin::V1
  class CategoriesController < ApiController
    def index
      @categories = Category.all
    end

    def create
      @category = Category.new
      @category.attributes = category_params
      save_category
    end

    def update
      @category = Category.find(params[:id])
      @category.attributes = category_params
     save_category
    end

    private

    def save_category
      @category.save!
      render :show
    rescue
      render_errors(fields: @category.errors.messages)
    end

    def category_params
      return {} unless params.has_key?(:category)
      params.require(:category).permit(:id, :name)
    end
  end
end
