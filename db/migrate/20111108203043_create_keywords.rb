# -*- encoding : utf-8 -*-
class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.string :tchat
      t.string :area
      t.string :set_infos
      t.string :get_infos
      t.string :initiate_relationship
      t.string :activate_relationship
      t.string :break_relationship
      t.string :help

      t.timestamps
    end
  end

  def self.down
    drop_table :keywords
  end
end
