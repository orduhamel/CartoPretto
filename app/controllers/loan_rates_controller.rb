require 'csv'

class LoanRatesController < ApplicationController
  before_action :set_loan_rate, only: %i[ show edit update destroy ]

  # GET /loan_rates or /loan_rates.json
  def map
    @loan_rates = LoanRate.all
  end

  # POST /loan_rates or /loan_rates.json
  def create
    @loan_rate = LoanRate.new(loan_rate_params)

    respond_to do |format|
      if @loan_rate.save
        format.html { redirect_to loan_rate_url(@loan_rate), notice: "Loan rate was successfully created." }
        format.json { render :show, status: :created, location: @loan_rate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loan_rates/1 or /loan_rates/1.json
  def update
    respond_to do |format|
      if @loan_rate.update(loan_rate_params)
        format.html { redirect_to loan_rate_url(@loan_rate), notice: "Loan rate was successfully updated." }
        format.json { render :show, status: :ok, location: @loan_rate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loan_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loan_rates/1 or /loan_rates/1.json
  def destroy
    @loan_rate.destroy

    respond_to do |format|
      format.html { redirect_to loan_rates_url, notice: "Loan rate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_rate
      @loan_rate = LoanRate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loan_rate_params
      params.require(:loan_rate).permit(:address, :rate)
    end
end
