class AddJobsTable < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string   :name
      t.text     :description
      t.string   :location
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :jobs, [:user_id]

    change_column :users, :state, :string, :limit => 255, :default => "unverified"
  end

  def self.down
    change_column :users, :state, :string, :default => "active"

    drop_table :jobs
  end
end
