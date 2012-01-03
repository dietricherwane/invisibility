class AddCreationDateToCounters < ActiveRecord::Migration
  def self.up
    add_column :counters, :creation_date, :date
  end

  def self.down
    remove_column :counters, :creation_date
  end
end
