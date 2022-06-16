class RenameColumnsInProjects < ActiveRecord::Migration[6.1]
  def change
    rename_column :projects, :address, :adresse_complete
    rename_column :projects, :age, :age_moyen
    rename_column :projects, :grid_decote, :grid_decote_rate
  end
end
