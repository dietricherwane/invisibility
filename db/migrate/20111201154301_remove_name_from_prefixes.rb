class RemoveNameFromPrefixes < ActiveRecord::Migration
  def self.up
    remove_column :prefixes, :name
  end

  def self.down
    add_column :prefixes, :name, :integer
  end
end
