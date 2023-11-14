# frozen_string_literal: true

# Transaction model
class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'Account'
  belongs_to :receiver, class_name: 'Account'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :error_message, presence: true
  validate :sender_and_receiver_are_different

  enum status: { pending: 0, completed: 1, failed: 2 }

  private

  def sender_and_receiver_are_different
    return unless sender_id == receiver_id

    errors.add(:base, 'Sender and receiver must be different')
  end
end
