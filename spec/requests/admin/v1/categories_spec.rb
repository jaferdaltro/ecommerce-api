require 'rails_helper'

RSpec.describe "Admin::V1::Categories", type: :request do
  let(:user) { create(:user) }
  let(:url) { '/admin/v1/categories' }

  describe "GET /index" do
    let!(:categories) { create_list(:category, 5) }

    it "should returs all categories" do
      get url, headers: auth_header(user)

      expect(body_json['categories']).to contain_exactly *categories.as_json(only: %i(id name))
    end

  end

  describe "POST /index" do
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
end
