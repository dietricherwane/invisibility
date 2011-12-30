class AddOperatorIdToPrefixes < ActiveRecord::Migration
  def self.up
    add_column :prefixes, :operator_id, :integer
  end

  def self.down
    remove_column :prefixes, :operator_id
  end
end
