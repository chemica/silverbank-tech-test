# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    let(:user) do
      User.create(display_name: 'test', email: 'henry@example.com')
    end

    let(:account) do
      Account.create(balance: 100, friendly_name: 'test', user:)
    end

    describe 'associations' do
      it { should belong_to(:sender).class_name('Account') }
      it { should belong_to(:receiver).class_name('Account') }
    end

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:error_message) }

    it 'should validate that sender and receiver are different' do
      transaction = Transaction.new(sender: account, receiver: account, amount: 50)
      transaction.valid?
      expect(transaction.errors[:base]).to include('Sender and receiver must be different')
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, completed: 1, failed: 2) }
  end
end
