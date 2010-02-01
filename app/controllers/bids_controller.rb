class BidsController < ApplicationController

  hobo_model_controller

  auto_actions :write_only, :show
  auto_actions_for :project, [:create, :new, :index]

end
