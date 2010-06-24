class Job < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string, :required
    description :text, :required
    location    :string
    pay         :string
    hours       enum_string(:full_time,:part_time,:special)
    duration    :string
    email_address :email_address
    timestamps
  end

  include OwnedModel

end
