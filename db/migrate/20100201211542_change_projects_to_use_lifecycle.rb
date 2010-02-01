class ChangeProjectsToUseLifecycle < ActiveRecord::Migration
  def self.up
    add_column :projects, :description, :text
    add_column :projects, :due, :datetime
    add_column :projects, :state, :string, :default => "open"
    add_column :projects, :key_timestamp, :datetime
    remove_column :projects, :status

    add_index :projects, [:state]
  end

  def self.down
    remove_column :projects, :description
    remove_column :projects, :due
    remove_column :projects, :state
    remove_column :projects, :key_timestamp
    add_column :projects, :status, :string

    remove_index :projects, :name => :index_projects_on_state rescue ActiveRecord::StatementInvalid
  end
end
