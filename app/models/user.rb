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

  passwordless_with :email

  validate :account_name_is_unique, on: :create
  validate :account_name_is_valid, on: :create

  after_save :create_account

  attr_accessor :account_name

  private

  def account_name_is_valid
    return if account_name =~ Account.valid_friendly_name_regex

    errors.add(:account_name, 'is invalid')
  end

  def account_name_is_unique
    return unless Account.find_by(friendly_name: account_name)

    errors.add(:account_name, 'is already taken')
  end

  def create_account
    Account.create(friendly_name: account_name, user: self)
  end
end
