# -*- encoding : utf-8 -*-
class CreateRelations < ActiveRecord::Migration
  def self.up
    create_table :relations do |t|
      t.integer :user_id
      t.string :target
      t.datetime :broken_at
      t.boolean :status

      t.timestamps
    end
  end

  def self.down
    drop_table :relations
  end
end
