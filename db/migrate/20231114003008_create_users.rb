# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :display_name, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :display_name, unique: true
  end
end
