class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :address
      t.string :zipcode
      t.string :rate

      t.timestamps
    end
  end
end
