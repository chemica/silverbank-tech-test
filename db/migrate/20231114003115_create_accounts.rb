# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :friendly_name, null: false
      t.decimal :balance, null: false, default: 0.0

      t.timestamps
    end

    add_index :accounts, :friendly_name, unique: true
  end
end
