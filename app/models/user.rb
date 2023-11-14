# frozen_string_literal: true

# User model
class User < ApplicationRecord
  has_one :account, dependent: :destroy

  validates :display_name, presence: true,
                           uniqueness: true,
                           length: { minimum: 3, maximum: 60 }

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    length: { minimum: 3, maximum: 254 }
end
