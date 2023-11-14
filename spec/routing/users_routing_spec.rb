require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    let(:user) do
      User.create id: '123e4567-e89b-12d3-a456-426614174000', display_name: 'Display name', email: 'someone@example.com'
    end

    it 'routes to #new' do
      expect(get: '/users/new').to route_to('users#new')
    end

    it 'routes to #profile' do
      expect(get: '/users/profile').to route_to('users#show')
    end
    it 'routes to #create' do
      expect(post: '/users').to route_to('users#create')
    end
  end
end
