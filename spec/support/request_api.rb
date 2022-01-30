module RequestAPI
  def body_json(symbolize_keys: false)
    json = JSON.parse(response.body)
    symbolize_keys ? json.deep_symbolize_keys : json
  end

  def auth_header(user = nil, options: {})
    user ||= create(:user)
    auth = user.create_new_auth_token
    header = auth.merge({ 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    header.merge options
  end
end


RSpec.configure do |config|
  config.include RequestAPI, type: :request
end