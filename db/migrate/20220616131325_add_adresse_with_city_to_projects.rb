class AddAdresseWithCityToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :adresse_with_city, :string
  end
end
