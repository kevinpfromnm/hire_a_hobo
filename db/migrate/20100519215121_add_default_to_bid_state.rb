class AddDefaultToBidState < ActiveRecord::Migration
  def self.up
    change_column :bids, :state, :string, :limit => 255, :default => "open"
  end

  def self.down
    change_column :bids, :state, :string
  end
end
