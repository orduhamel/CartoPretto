class ChangeDurationInProjects < ActiveRecord::Migration[6.1]
  def change
    change_column :projects, :duration, :string
  end
end
