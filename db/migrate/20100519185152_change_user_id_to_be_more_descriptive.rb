class ChangeUserIdToBeMoreDescriptive < ActiveRecord::Migration
  def self.up
    rename_column :bids, :user_id, :bidder_id

    remove_index :bids, :name => :index_bids_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :bids, [:bidder_id]
  end

  def self.down
    rename_column :bids, :bidder_id, :user_id

    remove_index :bids, :name => :index_bids_on_bidder_id rescue ActiveRecord::StatementInvalid
    add_index :bids, [:user_id]
  end
end
