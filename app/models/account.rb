# frozen_string_literal: true

# Account model
class Account < ApplicationRecord
  belongs_to :user

  validates :friendly_name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 60 }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
