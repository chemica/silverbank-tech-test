# frozen_string_literal: true

# Account model
class Account < ApplicationRecord
  @valid_friendly_name_regex = /\A[a-zA-Z0-9_-]+\z/
  @valid_friendly_name_length = { minimum: 3, maximum: 60 }
  class << self
    attr_reader :valid_friendly_name_regex, :valid_friendly_name_length
  end

  belongs_to :user

  validates :friendly_name,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 60 },
            format: valid_friendly_name_regex
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  after_create :add_promotion_funds

  private

  def add_promotion_funds
    return unless ENV['PROMO_RUNNING'] == 'true' && ENV['PROMO_AMOUNT'].to_i.positive?

    update!(balance: balance + ENV['PROMO_AMOUNT'].to_i)
  end
end
