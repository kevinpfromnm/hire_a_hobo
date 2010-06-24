class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name          :string, :required, :unique
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    timestamps
  end

  has_many :projects
  has_many :bids, :foreign_key => "bidder_id"
  has_many :bidded_projects, :through => :bids, :class_name => "Project"

  
  def satisfaction_ratio
    satisfied = bids.completed_bids.count
    unsatisfied = bids.unsatisfactory_bids.count
    
    ratio = satisfied / (satisfied + unsatisfied) unless satisfied + unsatisfied == 0
    ratio ||= "No projects finished to completion (not counting active)"
    ratio
  end

  def current_commitments
    count = bids.active_bids.count
    count = "No active unfinished projects" if count == 0
    count
  end
  # --- Signup lifecycle --- #

  lifecycle do

    state :unverified, :default => true
    state :active

    create :signup, :available_to => "Guest",
           :params => [:name, :email_address, :password, :password_confirmation],
           :become => :unverified, :new_key => true do
      UserMailer.deliver_email_verification(self, lifecycle.key)
    end

    transition :verify_email_address, { :unverified => :active }, :available_to => :key_holder do
      UserMailer.deliver_email(self,"Email address verified","Your email address has been verified.")
    end
             
    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.deliver_forgot_password(self, lifecycle.key)
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

    transition :change_email, { :active => :unverified }, 
                :available_to => :user_account,
                :params => [ :email_address ], :new_key => true do
      UserMailer.deliver_email_verification(self, lifecycle.key)
    end

  end
 
  def submit_permitted?
    signed_up?
  end 

  def user_account
    self
  end

  # --- Permissions --- #

  def create_permitted?
    false
  end

  def update_permitted?
    acting_user.administrator? || 
      (acting_user == self && only_changed?(:crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    return true if acting_user == self
    return false if field == :email_address
    true
  end

end
