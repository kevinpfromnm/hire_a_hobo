class BidsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => [:update, :edit, :index]
  auto_actions_for :project, [:create, :new, :index]

end
