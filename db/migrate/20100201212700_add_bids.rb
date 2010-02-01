class AddBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.string   :amount
      t.string   :time_estimate
      t.text     :notes
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
      t.integer  :user_id
    end
    add_index :bids, [:project_id]
    add_index :bids, [:user_id]
  end

  def self.down
    drop_table :bids
  end
end
