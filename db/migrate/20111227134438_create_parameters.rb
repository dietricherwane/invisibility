class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.string :break_relationship
      t.string :registration
      t.string :area
      t.string :informations
      t.string :initiate_relationship
      t.string :accept

      t.timestamps
    end
  end

  def self.down
    drop_table :parameters
  end
end
