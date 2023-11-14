require 'rails_helper'

RSpec.xcontext 'transactions/edit', type: :view do
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

  let(:transaction) do
    Transaction.create!(
      sender: account1,
      receiver: account2,
      amount: '9.99',
      status: 1,
      error_message: 'MyString'
    )
  end

  before(:each) do
    assign(:transaction, transaction)
  end

  it 'renders the edit transaction form' do
    render

    assert_select 'form[action=?][method=?]', transaction_path(transaction), 'post' do
      assert_select 'input[name=?]', 'transaction[sender_id]'

      assert_select 'input[name=?]', 'transaction[receiver_id]'

      assert_select 'input[name=?]', 'transaction[amount]'

      assert_select 'input[name=?]', 'transaction[status]'

      assert_select 'input[name=?]', 'transaction[error_message]'
    end
  end
end
