class AddNameToPrefixes < ActiveRecord::Migration
  def self.up
    add_column :prefixes, :name, :string
  end

  def self.down
    remove_column :prefixes, :name
  end
end
