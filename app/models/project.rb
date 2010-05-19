class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string, :required
    budget      :string, :required
    description :text, :required
    due         :datetime
    timestamps
  end

  include OwnedModel

  has_many :bids
  has_many :bidders, :through => :bids, :class_name => "User"

  def already_bidded?(bidder)
    bidders.include? bidder
  end

  lifecycle do
    state :open, :default => true
    state :in_progress, :completed_awaiting_payment, :closed

    create :add_project, :available_to => "User",
      :params => [:name, :budget, :description, :due ],
      :become => :open do
        # send confirmation
    end

    transition :accept_bid, { :open => :in_progress },
      :available_to => :user do
    end

    # :open => :in_progress, probably should happen via accepting a bid

    transition :completed, 
      { :in_progress => :completed_awaiting_payment }, 
      :available_to => :user do
        # send notice to bidder
    end

    # transition :acknowledge_payment, 
    #   {:completed_awaiting_payment => :closed }, 
    #   :available_to => employee do
    #     # send confirmation to employer
    # end

  end

end
