# -*- encoding : utf-8 -*-
class CreateContainers < ActiveRecord::Migration
  def self.up
    create_table :containers do |t|
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :containers
  end
end
