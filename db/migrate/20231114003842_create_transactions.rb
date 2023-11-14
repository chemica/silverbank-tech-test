# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.uuid :sender_id, null: false
      t.uuid :receiver_id, null: false
      t.decimal :amount, null: false
      t.integer :status, null: false, default: 0
      t.string :error_message, null: false, default: ''

      t.timestamps
    end

    add_foreign_key :transactions, :accounts, column: :sender_id
    add_foreign_key :transactions, :accounts, column: :receiver_id
  end
end
