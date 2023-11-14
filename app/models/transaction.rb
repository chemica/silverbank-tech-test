# frozen_string_literal: true

class InsufficientBalanceError < StandardError; end

# Transaction model
class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'Account'
  belongs_to :receiver, class_name: 'Account'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validate :sender_and_receiver_are_different

  enum status: { pending: 0, completed: 1, failed: 2 }

  def execute!
    return unless pending?

    transact
  rescue InsufficientBalanceError
    update!(status: :failed)
    update!(error_message: 'Sender has insufficient funds')
  rescue StandardError
    update! status: :failed
    update! error_message: 'Server error'
  end

  private

  def transact
    Account.transaction do
      s, r = lock_sender_and_receiver_accounts
      raise InsufficientBalanceError, 'Insufficient funds' unless sender_balance_is_sufficient?(s.balance)

      s.balance -= amount
      s.save!
      r.balance += amount
      r.save!
      update! status: :completed
    end
  end

  def lock_sender_and_receiver_accounts
    [Account.lock('FOR UPDATE NOWAIT').find_by(id: sender.id),
     Account.lock('FOR UPDATE NOWAIT').find_by(id: receiver.id)]
  end

  def sender_balance_is_sufficient?(sender_balance)
    sender_balance >= amount
  end

  def sender_and_receiver_are_different
    return unless sender_id == receiver_id

    errors.add(:base, 'Sender and receiver must be different')
  end
end
