require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  describe 'GET /account' do
    let(:user) do
      User.create!(display_name: 'user', email: 'sandra@example.com', account_name: 'my-account')
    end

    context 'when logged in' do
      it 'returns http success' do
        passwordless_sign_in user
        get '/account'
        expect(response).to have_http_status(:success)
      end
    end

    context 'when not logged in' do
      it 'redirects' do
        get '/account'
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
