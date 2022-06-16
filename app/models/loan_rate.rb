require 'csv'

class LoanRate < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.load_csv_file(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      # TODO : Convert data into integer, float or other type
      # EX : year = row[1].to_i
      LoanRate.create!(row.to_hash)
    end
  end
end
