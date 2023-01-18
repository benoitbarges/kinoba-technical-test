# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_01_16_130308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "catched_pokemons", force: :cascade do |t|
    t.bigint "pokemon_id", null: false
    t.bigint "trainer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pokemon_id"], name: "index_catched_pokemons_on_pokemon_id"
    t.index ["trainer_id"], name: "index_catched_pokemons_on_trainer_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.string "abilities", default: [], array: true
    t.integer "base_experience", default: 0
    t.integer "base_happiness", default: 0
    t.integer "capture_rate", default: 0
    t.string "color"
    t.string "description"
    t.string "egg_groups", default: [], array: true
    t.integer "gender_rate"
    t.string "growth_rate"
    t.integer "height", default: 0
    t.string "jap_name"
    t.boolean "legendary", default: false
    t.boolean "mythical", default: false
    t.string "name"
    t.string "shape"
    t.string "species"
    t.integer "hp", default: 0
    t.integer "attack", default: 0
    t.integer "defense", default: 0
    t.integer "special_attack", default: 0
    t.integer "special_defense", default: 0
    t.integer "speed", default: 0
    t.string "types", default: [], array: true
    t.integer "weight", default: 0
    t.integer "generation"
    t.string "image_url"
    t.bigint "ancestor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestor_id"], name: "index_pokemons_on_ancestor_id"
  end

  create_table "trainers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_trainers_on_email", unique: true
    t.index ["jti"], name: "index_trainers_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_trainers_on_reset_password_token", unique: true
  end

  add_foreign_key "catched_pokemons", "pokemons"
  add_foreign_key "catched_pokemons", "trainers"
  add_foreign_key "pokemons", "pokemons", column: "ancestor_id"
end
