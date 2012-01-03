class CreateCounters < ActiveRecord::Migration
  def self.up
    create_table :counters do |t|
      t.string :phone_number
      t.integer :sms_number

      t.timestamps
    end
  end

  def self.down
    drop_table :counters
  end
end
