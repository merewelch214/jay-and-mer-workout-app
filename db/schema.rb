# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 4) do

  create_table "logs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "workout_id"
    t.datetime "date"
    t.string "mood"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.integer "age"
    t.integer "weight"
    t.integer "calorie_goal"
  end

  create_table "workouts", force: :cascade do |t|
    t.string "category"
    t.string "description"
    t.integer "difficulty"
    t.integer "calories_burned"
    t.integer "duration"
  end

end
