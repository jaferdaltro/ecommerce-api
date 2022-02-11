require 'rails_helper'

RSpec.describe "Admin::V1::Categories", type: :request do
  let(:user) { create(:user) }
  let(:url) { '/admin/v1/categories' }

  describe "GET /categories" do
    let!(:categories) { create_list(:category, 5) }

    it "should returs all categories" do
      get url, headers: auth_header(user)

      expect(body_json['categories']).to contain_exactly *categories.as_json(only: %i(id name))
    end

  end

  describe "POST /categories" do
    let(:category_params) { {category: attributes_for(:category)}.to_json }

    context "with valid params" do

      it "adds a new category" do
        expect do
          post url, headers: auth_header(user), params: category_params
        end.to change(Category, :count).by 1
      end

      it "returs last added category" do
        post url, headers: auth_header(user), params: category_params
        expected_category = Category.last.as_json(only: %i(id name))

        expect(body_json['category']).to eq expected_category
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: category_params

        expect(response).to have_http_status :ok
      end
    end

    context "with invalid params" do
      let(:invalid_params) { {category: attributes_for(:category, name: nil) }.to_json }

      it "does not add a new category" do
        expect do
          post url, headers: auth_header(user), params: invalid_params
        end.to_not change(Category, :count)
      end

      it "returns message error" do
        post url, headers: auth_header(user), params: invalid_params

        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "returns unprocessable_entity status" do
        post url, headers: auth_header(user), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    context "with valid params" do
      let(:new_name) { "new category name" }
      let(:category_params) { { category: { name: new_name } }.to_json }

      it "update category" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(category.name).to eq new_name
      end
      
      it "returns updated category" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expected_category = category.as_json(only: %i(id name))
        expect(body_json['category']).to eq expected_category
      end


      it "returns success status" do
        patch url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status :ok
      end
    end

    context "with invalid param" do
      # let(:invalid_param) { { category: {name: "" } }.to_json }
      let(:invalid_param) do 
        { category: attributes_for(:category, name: nil) }.to_json
      end
      
      it "does not update category" do
        patch url, headers: auth_header(user), params: invalid_param
        category.reload
        expect(category.name).to_not eq invalid_param
      end

      it "returns message error" do
        patch url, headers: auth_header(user), params: invalid_param
        expect(body_json['errors']['fields']).to have_key 'name'
      end

      it "returns unprocessable_entity status" do
        patch url, headers: auth_header(user), params: invalid_param
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe "DELETE /categories/:id" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }
    
    it "removes category" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Category, :count).by -1
    end
    it "returns success status" do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status :no_content
    end
    it "does not return any body content" do
      delete url, headers: auth_header(user)
      expect(response['body']).to eq nil
      # expect(body_json).to_not be_present
    end
    it "remove all associated product category" do
      product_categories = create_list(:product_category, 3, category: category)
      delete url, headers: auth_header(user)
      expected_products = ProductCategory.where(id: product_categories.map(&:id))
      expect(expected_products.count).to eq 0
    end
    it "does not remove any unassociated category" do
      
    end
  end
end
