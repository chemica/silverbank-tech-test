require 'rails_helper'

RSpec.describe 'transactions/show', type: :view do
  let(:user1) do
    User.create! display_name: 'xxx1', email: 'xxx1@example.com'
  end

  let(:user2) do
    User.create! display_name: 'xxx2', email: 'xxx2@example.com'
  end

  let(:account1) do
    Account.create! user: user1, friendly_name: 'acc1', balance: 100.0
  end

  let(:account2) do
    Account.create! user: user2, friendly_name: 'acc2', balance: 100.0
  end

  before(:each) do
    Transaction.destroy_all
    assign(:transaction, Transaction.create!(
                           sender: account1,
                           receiver: account2,
                           amount: '9.99',
                           status: 2,
                           error_message: 'Error Message'
                         ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Error Message/)
  end
end
