class Bid < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    amount        :string
    time_estimate :string
    notes         :text
    timestamps
  end

  belongs_to :project

  belongs_to :user, :creator => true

  def create_permitted?
    return true if acting_user.administrator?
    acting_user.signed_up? and user_is? acting_user and acting_user.submit_permitted?  
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(attribute)
    user_is? acting_user or project_owner == acting_user
  end

  def project_owner
    project.user
  end

  def name
    amount
  end

  lifecycle do
    state :open, :accepted, :rejected

    create :place_bid, 
      :params => [:amount, :time_estimate, :notes, :project_id], 
      :become => :open,
      :available_to => "User",
      :user_becomes => :user do
    end

    transition :accept, { :open => :accepted }, 
      :available_to => :project_owner do
        project.lifecycle.accept_bid!(acting_user)
        # remove other bids here?
    end
  end
end
