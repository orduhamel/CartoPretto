class AddColumnsToProjects < ActiveRecord::Migration[6.1]
  def up
    add_column :projects, :street, :string
    add_column :projects, :duration, :integer
    add_column :projects, :sent_rate, :float
    add_column :projects, :rate_obtained, :float
    add_column :projects, :grid_rate, :float
    add_column :projects, :grid_decote, :float
    add_column :projects, :age, :integer
    add_column :projects, :nb_mortgagors, :integer
    add_column :projects, :total_income, :integer
    add_column :projects, :loan_amount, :integer
    add_column :projects, :date_obtained, :datetime

    remove_column :projects, :rate, :float
  end

  def down
    remove_column :projects, :street, :string
    remove_column :projects, :duration, :integer
    remove_column :projects, :sent_rate, :float
    remove_column :projects, :rate_obtained, :float
    remove_column :projects, :grid_rate, :float
    remove_column :projects, :grid_decote, :float
    remove_column :projects, :age, :integer
    remove_column :projects, :nb_mortgagors, :integer
    remove_column :projects, :total_income, :integer
    remove_column :projects, :loan_amount, :integer
    remove_column :projects, :date_obtained, :datetime

    add_column :projects, :rate, :float
  end
end
