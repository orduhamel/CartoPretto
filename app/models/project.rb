require 'csv'

class Project < ApplicationRecord
  geocoded_by :adresse_complete
  validates :adresse_complete, presence: true
  validates :rate_obtained, presence: true

  after_validation :geocode, if: :will_save_change_to_adresse_complete?

  def self.load_csv_file(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      # TODO : Convert data into integer, float or other type
      # EX : year = row[1].to_i
      Project.create!(row.to_hash)
    end
  end
end
