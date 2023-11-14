# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user) do
    User.create!(display_name: 'test', email: 'sharon@example.com', account_name: 'new-account')
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { Account.create(friendly_name: 'Savings', balance: 100, user:) }

    it { should validate_presence_of(:friendly_name) }
    it { should validate_uniqueness_of(:friendly_name) }
    it { should validate_length_of(:friendly_name).is_at_least(3).is_at_most(60) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end
end
