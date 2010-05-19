class AddFlagForProjectOpen < ActiveRecord::Migration
  def self.up
    add_column :projects, :open_for_bids, :boolean, :default => true
  end

  def self.down
    remove_column :projects, :open_for_bids
  end
end
