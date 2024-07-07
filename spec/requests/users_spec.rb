require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  # Test suite for GET /users
  describe 'GET /users' do
    before { get '/users' }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for POST /users
  describe 'POST /users' do
    let(:valid_attributes) { { user: { name: 'Alice', email: 'alice@example.com', campaigns_list: [{ campaign_name: 'cam4', campaign_id: 'id4' }] } } }
    let(:invalid_attributes) { { user: { name: '', email: 'not_an_email' } } }

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes }

      it 'creates a user' do
        expect(json['name']).to eq('Alice')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/)
        expect(response.body).to match(/is invalid/)
      end
    end
  end

  # Test suite for GET /users/filter
  describe 'GET /users/filter' do
    let!(:user1) { create(:user, campaigns_list: [{ campaign_name: 'cam1', campaign_id: 'id1' }, { campaign_name: 'cam2', campaign_id: 'id2' }]) }
    let!(:user2) { create(:user, campaigns_list: [{ campaign_name: 'cam2', campaign_id: 'id2' }, { campaign_name: 'cam3', campaign_id: 'id3' }]) }

    context 'when filtering by single campaign' do
      before { get '/users/filter', params: { campaign_names: 'cam1' } }

      it 'returns users with specified campaign' do
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
        expect(json.first['id']).to eq(user1.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when filtering by multiple campaigns' do
      before { get '/users/filter', params: { campaign_names: 'cam1,cam2' } }

      it 'returns users with any of the specified campaigns' do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
