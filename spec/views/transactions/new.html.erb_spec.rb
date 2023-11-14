require 'rails_helper'

RSpec.xcontext "transactions/new", type: :view do
  before(:each) do
    assign(:transaction, Transaction.new(
      sender: nil,
      receiver: nil,
      amount: "9.99",
      status: 1,
      error_message: "MyString"
    ))
  end

  it "renders new transaction form" do
    render

    assert_select "form[action=?][method=?]", transactions_path, "post" do

      assert_select "input[name=?]", "transaction[sender_id]"

      assert_select "input[name=?]", "transaction[receiver_id]"

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[status]"

      assert_select "input[name=?]", "transaction[error_message]"
    end
  end
end
