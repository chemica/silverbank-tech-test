# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    assign(:users, [
             User.create!(
               display_name: 'Display Name1',
               email: 'someone@example.com'
             ),
             User.create!(
               display_name: 'Display Name2',
               email: 'someone_else@example.com'
             )
           ])
  end

  it 'renders a list of users' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Display Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Email'.to_s), count: 2
  end
end
