require 'rails_helper'

RSpec.describe "Admin::V1::Categories", type: :request do
  describe "GET /index" do
    let(:user) { create(:user)}
    let!(:categories) { create_list(:category, 5) }

    it "should returs all categories" do
      get '/admin/v1/categories', headers: auth_header(user)
      
      expect(body_json['categories']).to contain_exactly *categories.as_json(only: %i(id name))
    end

  end
end
