class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    hobo_index :scope => :open_projects
  end

  index_action :all

end
