class CreateAdministrators < ActiveRecord::Migration
  def self.up
    create_table :administrators do |t|
      t.string :email
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :administrators
  end
end
