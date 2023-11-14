require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    assign(:user, User.create!(
                    display_name: 'Display Name',
                    email: 'steve@example.com'
                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/Email/)
  end
end
