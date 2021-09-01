require 'rails_helper'

RSpec.describe "Endpoints", type: :request do
  describe "POST /create" do
    it "returns http success" do
      post '/create', params: { username: 'testing', password: 'password'}
      expect(response).to have_http_status(:created)
    end

    it 'returns failure and correct error when a field is missing' do
      post '/create', params: {username: 'testing'}
	    expect(response).to have_http_status(:bad_request)
	    expect(response.body.include?('password')).to eq true
    end
  end

  describe "post login" do
    it "fails on in-valid creds and returns an error" do
      post '/login', params:{username: 'tes'}
      expect(response).to have_http_status(:unauthorized)
      expect(response.body.include?('error')).to eq true
    end

    it "fails on wrong password and returns an error" do
      post '/login', params:{username: 'test1',password:'test'}
      expect(response).to have_http_status(:unauthorized)
      expect(response.body.include?('error')).to eq true
    end

    it "returns http success on valid creds and unauthorised on invalid creds" do
	    post '/login', params:{username: 'test1', password: 'password', addition: 'gg'}
      expect(response).to have_http_status(:success)
	    expect(response.body.include?('token')).to eq true
    end
  end

  describe "functionality around url generation" do
    it 'fails request to API without authorization token' do
      post "/create_short_url", params: { url: 'http://google.com' }
      expect(response).to have_http_status(:unauthorized)
    end

    it "create url without url, " do
      test_user = User.create(username: 'romo', password: 'test')
      expect(test_user.token).to eq nil
      test_user.generate_token
      expect(test_user.token).to_not eq nil
      # bad request to create without url
      post "/create_short_url", headers: {Authorization: test_user.token}
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include("can't be blank")
      # good request
      post "/create_short_url", params: { url: 'http://google.com' }, headers: {Authorization: test_user.token}
      expect(response).to have_http_status(:success)
      short_link = response.body
      #request to retreive using short link
      get "/url", params: { link: short_link }, headers: {Authorization: test_user.token}
    end
  end
end
