class ProjectsController < ApplicationController
  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  def map
    @projects = Project.all

    # the `geocoded` scope filters only flats with coordinates (latitude & longitude)
    @markers = @projects.geocoded.map do |project|
      {
        lat: project.latitude,
        lng: project.longitude
      }
    end
  end
end
