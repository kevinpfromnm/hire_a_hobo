class NoNeedForOpenBooleanConvenienceWinningBidRelation < ActiveRecord::Migration
  def self.up
    add_column :projects, :winning_bid_id, :integer
    remove_column :projects, :open_for_bids

    add_index :projects, [:winning_bid_id]
  end

  def self.down
    remove_column :projects, :winning_bid_id
    add_column :projects, :open_for_bids, :boolean, :default => true

    remove_index :projects, :name => :index_projects_on_winning_bid_id rescue ActiveRecord::StatementInvalid
  end
end
