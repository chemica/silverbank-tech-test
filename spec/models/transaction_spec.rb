# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) do
    User.create(display_name: 'test', email: 'henry@example.com', account_name: 'new-account')
  end

  let(:account) do
    Account.create(balance: 100, friendly_name: 'test', user:)
  end

  describe 'validations' do
    describe 'associations' do
      it { should belong_to(:sender).class_name('Account') }
      it { should belong_to(:receiver).class_name('Account') }
    end

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:status) }

    it 'should validate that sender and receiver are different' do
      transaction = Transaction.new(sender: account, receiver: account, amount: 50)
      transaction.valid?
      expect(transaction.errors[:base]).to include('Sender and receiver must be different')
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, completed: 1, failed: 2) }
  end

  describe 'transferring funds' do
    context 'when the sender has enough funds' do
      let(:sender) do
        Account.create!(balance: 50, friendly_name: 'test1', user:)
      end

      let(:receiver) do
        Account.create!(balance: 100, friendly_name: 'test2', user:)
      end

      let(:transaction) do
        Transaction.create!(sender:, receiver:, amount: 50, status: :pending)
      end

      it 'should transfer funds from the sender to the receiver' do
        transaction.execute!
        sender.reload
        receiver.reload
        expect(sender.balance).to eq 0
        expect(receiver.balance).to eq 150
      end

      it 'should mark the transaction as completed' do
        transaction.execute!
        expect(transaction.completed?).to be true
      end
    end

    context 'when the sender does not have enough funds' do
      let(:sender) do
        Account.create!(balance: 10, friendly_name: 'test3', user:)
      end

      let(:receiver) do
        Account.create!(balance: 100, friendly_name: 'test4', user:)
      end

      let(:transaction) do
        Transaction.create!(sender:, receiver:, amount: 50, status: :pending)
      end

      it 'should not transfer funds from the sender to the receiver' do
        transaction.execute!
        expect(transaction.sender.balance).to eq 10
        expect(transaction.receiver.balance).to eq 100
      end

      it 'should mark the transaction as failed' do
        transaction.execute!
        expect(transaction.failed?).to be true
      end

      it 'should record the failure reason' do
        transaction.execute!
        expect(transaction.error_message).to eq 'Sender has insufficient funds'
      end

      context 'when the transaction has failed' do
        let(:sender) do
          Account.create(balance: 50, friendly_name: 'test5', user:)
        end

        let(:receiver) do
          Account.create(balance: 100, friendly_name: 'test6', user:)
        end

        let(:transaction) do
          Transaction.create!(sender:, receiver:, amount: 50, status: :failed)
        end

        it 'should not transfer funds from the sender to the receiver' do
          transaction.execute!
          expect(sender.balance).to eq 50
          expect(receiver.balance).to eq 100
        end

        it 'should not mark the transaction as completed' do
          transaction.execute!
          expect(transaction.failed?).to be true
        end
      end

      context 'when the transaction has already completed' do
        let(:sender) do
          Account.create(balance: 50, friendly_name: 'test7', user:)
        end

        let(:receiver) do
          Account.create(balance: 100, friendly_name: 'test8', user:)
        end

        let(:transaction) do
          Transaction.create!(sender: user.account, receiver: account, amount: 50, status: :completed)
        end

        it 'should not transfer funds from the sender to the receiver' do
          transaction.execute!
          expect(sender.balance).to eq 50
          expect(receiver.balance).to eq 100
        end

        it 'should not mark the transaction as completed' do
          transaction.execute!
          expect(transaction.completed?).to be true
        end
      end
    end
  end
end
