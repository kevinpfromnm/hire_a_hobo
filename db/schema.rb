# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100201224727) do

  create_table "bids", :force => true do |t|
    t.string   "amount"
    t.string   "time_estimate"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "state"
    t.datetime "key_timestamp"
  end

  add_index "bids", ["project_id"], :name => "index_bids_on_project_id"
  add_index "bids", ["state"], :name => "index_bids_on_state"
  add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "budget"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "due"
    t.string   "state",         :default => "open"
    t.datetime "key_timestamp"
  end

  add_index "projects", ["state"], :name => "index_projects_on_state"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
