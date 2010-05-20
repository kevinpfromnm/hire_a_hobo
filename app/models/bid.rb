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
  attr_protected :bidder

  named_scope :other_bids, lambda { |bid_id| 
    { :conditions => ['id != ?',bid_id] } 
  }

  named_scope :open_bids, { 
    :conditions => ["bids.state LIKE 'open' and bids.state LIKE 'accepted'"]
  }

  named_scope :completed_bids, {  
    :conditions => "bids.state LIKE 'completed'"  }
  named_scope :unsatisfactory_bids, {  
    :conditions => "bids.state LIKE 'unsatisfactory'"  }
  named_scope :active_bids, {  
    :conditions => "bids.state LIKE 'accepted'" }

  named_scope :almost_finished_projects, {
    :include => :project,
    :conditions => ["projects.state LIKE 'completed_awaiting_payment'"]
  }

  def create_permitted?
    # No bids on nil projects, when bidder is not same as acting_user,
    # when bidder is project owner or has already bid, or when project is
    # closed
    return false unless project
    #return false unless bidder_is? acting_user
    return false if project.already_bidded?(acting_user)
    return false unless project.open_for_bids?
    comments == nil and rating == nil # and bidder == acting_user
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(attribute)
    return false if attribute == :rating and rating.blank?
    new_record? or bidder_is? acting_user or project_owner_is? acting_user
  end

  def project_owner
    project.try.user
  end

  def project_owner_is?(user)
    project.user_id == user.id
  end

  def status
    state
  end

  def name
    "#{bidder.to_s}'s bid: #{amount}"
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

    transition :resubmit_bid, { :rejected => :open }, 
      :available_to => :bidder, 
      :params => [ :amount, :time_estimate, :notes ] do
        comments = nil
        save
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
