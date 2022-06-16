require 'action_view'
include ActionView::Helpers::NumberHelper

class ProjectsController < ApplicationController
  before_action :set_projects

  def map
  end

  def map_results
    # the `geocoded` scope filters only flats with coordinates (latitude & longitude)
    @markers = @projects.geocoded.map do |project|
      {
        lat: project.latitude,
        lng: project.longitude,
        address: project.adresse_with_city,
        rate: project.rate_obtained,
        duration: project.duration,
        loan_amount: number_to_human(project.loan_amount, :format => '%n%u', :units => { :thousand => 'K' }),
        nb_mortgagors: project.nb_mortgagors,
        total_income: number_to_human(project.total_income, :format => '%n%u', :units => { :thousand => 'K' }),
        age: project.age_moyen
      }
    end

    render json: @markers
  end

  private

  def set_projects
    if params[:duration].present?
      @projects = Project.all.where(duration: params[:duration])
    else
      @projects = Project.all
    end
  end
end
