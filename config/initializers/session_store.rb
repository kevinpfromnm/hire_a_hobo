# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hire_a_hobo_session',
  :secret      => '31eebc332e0b8002d1f9ca300347279c101427e392a8b3b452d46af7258dd5c5a263e64c91f239517f35b52d4e9cc3ad35a0072770419b5fe0e846a1d19788ee'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
