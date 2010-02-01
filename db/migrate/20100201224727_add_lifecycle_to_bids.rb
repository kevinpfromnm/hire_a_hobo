class AddLifecycleToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :state, :string
    add_column :bids, :key_timestamp, :datetime

    add_index :bids, [:state]
  end

  def self.down
    remove_column :bids, :state
    remove_column :bids, :key_timestamp

    remove_index :bids, :name => :index_bids_on_state rescue ActiveRecord::StatementInvalid
  end
end
