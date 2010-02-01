class AddProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string   :name
      t.string   :budget
      t.string   :status
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :projects, [:user_id]
  end

  def self.down
    drop_table :projects
  end
end
