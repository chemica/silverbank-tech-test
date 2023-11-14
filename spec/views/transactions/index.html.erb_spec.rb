require 'rails_helper'

RSpec.describe 'transactions/index', type: :view do
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
    assign(:transactions, [
             Transaction.create!(
               sender: account1,
               receiver: account2,
               amount: '9.99',
               status: 1,
               error_message: 'Error Message'
             ),
             Transaction.create!(
               sender: account1,
               receiver: account2,
               amount: '9.99',
               status: 1,
               error_message: 'Error Message'
             )
           ])
  end

  it 'renders a list of transactions' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(account1.id.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(account2.id.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('9.99'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Error Message'.to_s), count: 2
  end
end
