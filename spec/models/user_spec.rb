# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.create(display_name: 'test', email: 'helen@example.com', account_name: 'new-account') }

  # Associations
  it { should have_one(:account).dependent(:destroy) }

  # Validations
  it { should validate_presence_of(:display_name) }
  it { should validate_uniqueness_of(:display_name) }
  it { should validate_length_of(:display_name).is_at_least(3).is_at_most(60) }
  it { should validate_presence_of(:account_name) }
  it { should validate_length_of(:account_name).is_at_least(3).is_at_most(60) }
  it { should allow_value('1234567890abc_-').for(:account_name) }
  it { should_not allow_value('!@#$%^&*()').for(:account_name) }
  it { should_not allow_value('no spaces').for(:account_name) }
  it { should_not allow_value('\r\n\t').for(:account_name) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('email@example.com').for(:email) }
  it { should_not allow_value('email@.com').for(:email) }
  it { should_not allow_value('email').for(:email) }
  it { should validate_length_of(:email).is_at_least(3).is_at_most(254) }
  it 'should not allow duplicate account account names' do
    User.create! display_name: 'test', email: 'rich@example.com', account_name: 'test1'
    should_not allow_value('test1').for(:account_name)
  end

  describe 'signup' do
    it 'creates an account for the user' do
      user = User.create(display_name: 'test', email: 'test@example.com', account_name: 'new-account')
      expect(user.account).to be_present
    end
  end
end
