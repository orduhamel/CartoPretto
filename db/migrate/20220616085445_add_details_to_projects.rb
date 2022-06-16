class AddDetailsToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :rn, :integer
  end
end
