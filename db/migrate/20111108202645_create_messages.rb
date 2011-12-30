# -*- encoding : utf-8 -*-
class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :user_id
      t.string :receiver
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
