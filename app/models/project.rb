require 'csv'

class Project < ApplicationRecord
  geocoded_by :adresse_complete
  validates :adresse_complete, presence: true
  validates :rate_obtained, presence: true

  after_validation :geocode, if: :will_save_change_to_adresse_complete?
  end
end
