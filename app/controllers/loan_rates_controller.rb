require 'csv'

class LoanRatesController < ApplicationController
  before_action :set_loan_rate, only: %i[ show edit update destroy ]

  # GET /loan_rates or /loan_rates.json
  def map
    @loan_rates = LoanRate.all

    @markers = @loan_rates.geocoded.map do |loan_rate|
      {
        lat: loan_rate.latitude,
        lng: loan_rate.longitude
      }
    end
  end

  def load_csv_file(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      # TODO : Convert data into integer, float or other type
      # EX : year = row[1].to_i
      LoanRate.create!(row.to_hash)
    end
  end
end
