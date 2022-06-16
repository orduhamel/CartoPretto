require 'action_view'
include ActionView::Helpers::NumberHelper

class ProjectsController < ApplicationController
  def map
    @projects = Project.all

    # the `geocoded` scope filters only flats with coordinates (latitude & longitude)
    @markers = @projects.geocoded.map do |project|
      {
        lat: project.latitude,
        lng: project.longitude,
        address: project.adresse_complete,
        rate: project.rate_obtained,
        duration: project.duration,
        loan_amount: project.loan_amount.round(-1),
        nb_mortgagors: project.nb_mortgagors,
        total_income: number_to_human(project.total_income, :format => '%n%u', :units => { :thousand => 'K' }),
        age: project.age_moyen
      }
    end
  end
end
