# -*- encoding : utf-8 -*-
class AddAreaToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :area, :string
  end

  def self.down
    remove_column :users, :area
  end
end
