class Bid < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    amount        :string, :required
    time_estimate :string
    notes         :text
    comments      :text
    rating        :integer
    timestamps
  end

  belongs_to :project

  belongs_to :bidder, :creator => true, :class_name => "User"

  named_scope :other_bids, lambda { |bid_id| 
    { :conditions => ['id != ?',bid_id] } 
  }

  named_scope :open_bids, { 
    :conditions => ["bids.state LIKE 'open' and bids.state LIKE 'accepted'"]
  }

  named_scope :almost_finished_projects, {
    :include => :project,
    :conditions => ["projects.state LIKE 'completed_awaiting_payment'"]
  }

  def create_permitted?
    #return true if acting_user.administrator?
    return false unless project
    return false if acting_user == project_owner
    return false if project.already_bidded?(acting_user)
    return false unless project.open_for_bids?
    true #bidder == acting_user
    comments == nil and rating == nil and (new_record? or bidder == acting_user)
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
    project.try.user
  end

  def name
    amount
  end


  lifecycle do
    state :open, :default => true
    state :accepted, :rejected, :other_bid_accepted, :completed, :unsatisfactory

    transition :accept_bid, { :open => :accepted }, 
      :available_to => :project_owner do
        project.lifecycle.accept_bid!(self)
        project.bids.other_bids(self.id).update_all "state = 'other_bid_accepted'"
        # TODO: notify winning bidder
    end

    transition :reject_bid, { :open => :rejected }, :params => [ :comments ],
      :available_to => :project_owner do
    end

    transition :project_completed_satisfactorily, { :accepted => :completed }, 
      :params => [ :comments, :rating ],
      :available_to => :project_owner do
        project.lifecycle.project_completed!(acting_user)
        # TODO: notify bidder
    end

    transition :project_completed_unsatisfactorily, { :accepted => :unsatisfactory }, 
      :params => [ :comments, :rating ],
      :available_to => :project_owner do
        project.lifecycle.completed!(acting_user)
        # TODO: notify bidder
    end
  end
end
