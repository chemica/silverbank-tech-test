require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:user) do
    User.create!(
      display_name: 'Display Name',
      email: 'steve@example.com'
    )
  end

  it 'renders attributes in <p>' do
    render template: 'users/show', layout: nil, locals: { current_user: user }
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/Email/)
  end
end
