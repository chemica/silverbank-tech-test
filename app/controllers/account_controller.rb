# frozen_string_literal: true

# Controller for the Account model
class AccountController < ApplicationController
  before_action :require_user!

  def show
    @account = current_user.account
    @transactions = Transaction.where(sender_id: @account.id)
                               .or(Transaction.where(receiver_id: @account_id))
                               .order(created_at: :desc).limit(10)
  end
end
