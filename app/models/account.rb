# frozen_string_literal: true

# Account model
class Account < ApplicationRecord
  @valid_friendly_name_regex = /\A[a-zA-Z0-9_-]+\z/
  class << self
    attr_reader :valid_friendly_name_regex
  end

  belongs_to :user

  validates :friendly_name,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 60 },
            format: valid_friendly_name_regex
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
