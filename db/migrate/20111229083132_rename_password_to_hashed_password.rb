class RenamePasswordToHashedPassword < ActiveRecord::Migration
  def self.up
  	rename_column :administrators, :password, :hashed_password
  end

  def self.down
  	rename_column :administrators, :hashed_password, :password
  end
end
