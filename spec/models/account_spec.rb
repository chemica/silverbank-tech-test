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

  describe 'promotion funds' do
    context 'when the promotion is running' do
      before do
        ENV['PROMO_RUNNING'] = 'true'
        ENV['PROMO_AMOUNT'] = '100'
      end
      it 'should apply the promotion funds on create' do
        user.account.reload
        expect(user.account.balance).to eq 100
      end
    end

    context 'when the promotion is not running' do
      before do
        ENV['PROMO_RUNNING'] = 'false'
        ENV['PROMO_AMOUNT'] = '100'
      end
      it 'should not apply the promotion funds on create' do
        user.account.reload
        expect(user.account.balance).to eq 0
      end
    end
  end
end
