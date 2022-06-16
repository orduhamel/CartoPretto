# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Parsing csv"
project_count = 0

CSV.foreach("lib/assets/project_data.csv", headers: true) do |row|
  next if row[3].nil? || row[6].nil?
  Project.create!(row.to_hash)
  project_count += 1
  puts "Project created ##{project_count}"
end

puts "Finished parsing"
