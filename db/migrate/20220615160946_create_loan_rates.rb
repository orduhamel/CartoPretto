class CreateLoanRates < ActiveRecord::Migration[6.1]
  def change
    create_table :loan_rates do |t|
      t.string :address
      t.string :rate

      t.timestamps
    end
  end
end
