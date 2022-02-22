require 'rails_helper'

RSpec.describe "Admin::V1::Categories as client", type: :request do
  let(:user) { create(:user, profile: :client)}

  context "GET /categories" do
    let(:url) { '/admin/v1/categories' }
    before(:each) { get url, headers: auth_header(user) }
  end
  
  context "POST /categories" do
    let(:url) { '/admin/v1/categories' }
    before(:each) { get url, headers: auth_header(user) }
    
  end
  
  context "PATCH /categories/:id" do
    let(:url) { '/admin/v1/categories/:id' }
    before(:each) { get url, headers: auth_header(user) }
    
  end
  
  context "DELETE /categories/:id" do
    let(:url) { '/admin/v1/categories/:id' }
    before(:each) { get url, headers: auth_header(user) }
    
  end
end