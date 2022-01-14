require 'rails_helper'

describe 'Authentication API', type: :request do
  describe 'POST /authenticate' do
    it 'authenticates a client' do
      post '/api/v1/authenticate', params: { username: 'admin', password: 'password' }
      expect(response).to have_http_status(:created)
      expect(response_body).to eq({
        'token' => '123'
      }) 
    end

    it 'returns error when username is missing' do
      post '/api/v1/authenticate', params: { password: 'password' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: username'
      })
    end

    it 'returns error when password is missing' do
      post '/api/v1/authenticate', params: { username: 'admin' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: password'
      })
    end
  end
end