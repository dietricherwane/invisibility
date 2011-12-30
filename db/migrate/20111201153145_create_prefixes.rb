class CreatePrefixes < ActiveRecord::Migration
  def self.up
    create_table :prefixes do |t|
      t.integer :name

      t.timestamps
    end
  end

  def self.down
    drop_table :prefixes
  end
end
