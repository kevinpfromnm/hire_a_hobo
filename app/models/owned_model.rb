OwnedModel = classy_module do
  
  belongs_to :user, :creator => true
  
  def create_permitted?
    user_is? acting_user  
  end
  
  def update_permitted?
    user_is? acting_user and !user_changed?
  end
  
  def destroy_permitted?
    acting_user.administrator? or user_is? acting_user
  end
  
  def view_permitted?(attribute)
    true
  end
end
