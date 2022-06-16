# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_16_131915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string "adresse_complete"
    t.string "zipcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
    t.string "street"
    t.string "duration"
    t.float "sent_rate"
    t.float "rate_obtained"
    t.float "grid_rate"
    t.float "grid_decote_rate"
    t.integer "age_moyen"
    t.integer "nb_mortgagors"
    t.integer "total_income"
    t.integer "loan_amount"
    t.datetime "date_obtained"
    t.integer "rn"
    t.string "adresse_with_city"
  end

end
