class Bid < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    amount        :string, :required
    time_estimate :string
    notes         :text
    timestamps
  end

  belongs_to :project

  belongs_to :bidder, :creator => true, :class_name => "User"

  def create_permitted?
    #return true if acting_user.administrator?
    return false if acting_user == project_owner
    return false if project.already_bidded?(acting_user)
    true #bidder == acting_user
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(attribute)
    new_record? or bidder_is? acting_user or project_owner == acting_user
  end

  def project_owner
    project.user
  end

  def name
    amount
  end

  named_scope :other_bids, lambda { |bid_id| { :conditions => ['id != ?',bid_id] } }

  lifecycle do
    state :open, :accepted, :rejected, :other_bid_accepted, :completed

    create :place_bid, 
      :params => [:amount, :time_estimate, :notes, :project_id], 
      :become => :open,
      :available_to => "User",
      :user_becomes => :user do
    end

    transition :accept_bid, { :open => :accepted }, 
      :available_to => :project_owner do
        project.lifecycle.accept_bid!(acting_user)
        project.bids.other_bids(self.id).update_all 'state = "other_bid_accepted"'
    end

    transition :reject_bid, { :open => :rejected }, 
      :available_to => :project_owner do
    end

  end
end
