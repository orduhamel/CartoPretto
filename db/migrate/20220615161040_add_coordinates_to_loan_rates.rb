class AddCoordinatesToLoanRates < ActiveRecord::Migration[6.1]
  def change
    add_column :loan_rates, :latitude, :float
    add_column :loan_rates, :longitude, :float
  end
end
