class AddEmailToJobPosting < ActiveRecord::Migration
  def self.up
    add_column :jobs, :email_address, :string
  end

  def self.down
    remove_column :jobs, :email_address
  end
end
