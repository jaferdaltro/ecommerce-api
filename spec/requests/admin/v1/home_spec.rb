require 'rails_helper'

describe 'Home', type: :request do
  let(:user) { create(:user) } 
  
  
  it "should return message" do
    get '/admin/v1/home', headers: auth_header(user)
    
    expect(body_json).to include({"message" => "uhuuuu"})
  end

 it "responds with ok" do
  get '/admin/v1/home', headers: auth_header(user)
    
  expect(response).to have_http_status :ok
 end
end