class AddCommentsToBidsForFinalization < ActiveRecord::Migration
  def self.up
    add_column :bids, :comments, :text
  end

  def self.down
    remove_column :bids, :comments
  end
end
