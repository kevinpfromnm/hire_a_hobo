class JobHints < Hobo::ViewHints

  model_name "Job Posting"
  field_help :duration => "ex. indefinite, 6 months, 3 months, etc.", 
      :hours => "If Special, include in description", 
      :location => "Use Remote if telecommuting is acceptable",
      :email_address => "Address for applications, leave blank if you require a different application process"
  # model_name "My Model"
  # field_names :field1 => "First Field", :field2 => "Second Field"
  # field_help :field1 => "Enter what you want in this field"
  # children :primary_collection1, :aside_collection1, :aside_collection2
end
