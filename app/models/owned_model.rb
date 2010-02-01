OwnedModel = classy_module do
  
  belongs_to :user, :creator => true
  
  def create_permitted?
    return true if acting_user.administrator?
    acting_user.signed_up? and user_is? acting_user and acting_user.submit_permitted?  
  end
  
  def update_permitted?
    return true if acting_user.administrator?
    user_is? acting_user and !user_changed? and acting_user.submit_permitted?
  end
  
  def destroy_permitted?
    acting_user.administrator? or user_is? acting_user
  end
  
  def view_permitted?(attribute)
    true
  end
end
