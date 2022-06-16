class LoanRatesController < ApplicationController
  # GET /loan_rates or /loan_rates.json
  def index
    @loan_rates = LoanRate.all
  end

  def map
    @loan_rates = LoanRate.all

    # the `geocoded` scope filters only flats with coordinates (latitude & longitude)
    @markers = @loan_rates.geocoded.map do |loan_rate|
      {
        lat: loan_rate.latitude,
        lng: loan_rate.longitude
      }
    end
  end
end
