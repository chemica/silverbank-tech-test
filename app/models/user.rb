# frozen_string_literal: true

# User model
class User < ApplicationRecord
  has_one :account, dependent: :destroy

  validates :display_name, presence: true,
                           uniqueness: true,
                           length: { minimum: 3, maximum: 60 }

  validates :email,        presence: true,
                           uniqueness: true,
                           format: { with: URI::MailTo::EMAIL_REGEXP },
                           length: { minimum: 3, maximum: 254 }

  validates :account_name, presence: true,
                           length: Account.valid_friendly_name_length,
                           format: Account.valid_friendly_name_regex
  passwordless_with :email

  validate :account_name_is_unique

  after_save :create_account

  attr_accessor :account_name

  private

  def account_name_is_unique
    return unless Account.find_by(friendly_name: account_name)

    errors.add(:account_name, 'is already taken')
  end

  def create_account
    Account.create!(friendly_name: account_name, user: self)
  end
end
