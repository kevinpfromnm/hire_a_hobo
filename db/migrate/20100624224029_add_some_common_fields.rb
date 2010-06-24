class AddSomeCommonFields < ActiveRecord::Migration
  def self.up
    add_column :jobs, :pay, :string
    add_column :jobs, :hours, :string
    add_column :jobs, :duration, :string
  end

  def self.down
    remove_column :jobs, :pay
    remove_column :jobs, :hours
    remove_column :jobs, :duration
  end
end
