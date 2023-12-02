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

ActiveRecord::Schema.define(version: 2023_12_02_130733) do

  create_table "documents", force: :cascade do |t|
    t.string "pdf_url"
    t.string "description"
    t.json "document_data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid"
  end

  create_table "line_items", force: :cascade do |t|
    t.string "description"
    t.float "price"
    t.integer "pdf_file_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pdf_file_id"], name: "index_line_items_on_pdf_file_id"
  end

  create_table "pdf_files", force: :cascade do |t|
    t.date "date"
    t.string "customer_name"
    t.string "customer_id"
    t.string "contract_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "line_items", "pdf_files"
end
