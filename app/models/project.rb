class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name          :string, :required
    budget        :string, :required
    description   :text, :required
    due           :datetime
    timestamps
  end

  never_show :winning_bid
  include OwnedModel

  has_many :bids
  has_many :bidders, :through => :bids, :class_name => "User"
  belongs_to :winning_bid, :class_name => "Bid"

  named_scope :open_projects, { :conditions => { :state => "open" } }

  def already_bidded?(bidder)
    bidders.include? bidder or user_is? bidder
  end

  def open_for_bids?
    state == "open"
  end

  def status
    state.humanize
  end

  def employee
    winning_bid.bidder
  end

  def employer
    user
  end

  def destroy_permitted?
    return false unless user_is? acting_user
    open_for_bids?
  end

  def view_permitted?(attribute)
    return true if user_is? acting_user
    return true if open_for_bids?
    return true if new_record?
    winning_bid.blank? or acting_user == employee
  end

  lifecycle do
    state :open, :default => true
    state :in_progress, :completed_awaiting_payment, :closed

    transition :accept_bid, { :open => :in_progress },
      :params => [ :winning_bid ] do
        # TODO: send notice to bidder
    end

    transition :project_completed, 
      { :in_progress => :completed_awaiting_payment } do
        # TODO: send notice to bidder
    end

    transition :acknowledge_payment, 
       {:completed_awaiting_payment => :closed }, 
       :available_to => :employee do
         # TODO: send confirmation to employer
    end

  end

end
