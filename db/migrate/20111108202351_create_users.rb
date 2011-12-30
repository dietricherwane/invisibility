# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :phone_number
      t.string :gender
      t.integer :age
      t.string :in_couple_with
      t.string :infos

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
