# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150323152414) do

  create_table "Doctor", primary_key: "LicenseNum", force: :cascade do |t|
    t.string "FirstName",   limit: 20
    t.string "LastName",    limit: 20
    t.string "Address",     limit: 50
    t.string "PhoneNumber", limit: 10
    t.string "Type",        limit: 20
  end

  add_index "Doctor", ["Address", "FirstName", "LastName"], name: "Address", unique: true, using: :btree

<<<<<<< HEAD
  create_table "Drug", id: false, force: :cascade do |t|
    t.string  "BrandName",   limit: 30, default: "", null: false
    t.string  "GenericName", limit: 30, default: "", null: false
    t.string  "CompanyName", limit: 30
    t.integer "Price",       limit: 4
  end

  create_table "Includes", id: false, force: :cascade do |t|
    t.string "PrescriptID", limit: 4,  default: "", null: false
    t.string "BrandName",   limit: 30, default: "", null: false
    t.string "GenericName", limit: 30, default: "", null: false
  end

  add_index "Includes", ["BrandName", "GenericName"], name: "BrandName", using: :btree

  create_table "InteractsWith", id: false, force: :cascade do |t|
    t.string "dBrandName",   limit: 30, default: "", null: false
    t.string "dGenericName", limit: 30, default: "", null: false
    t.string "iBrandName",   limit: 30, default: "", null: false
    t.string "iGenericName", limit: 30, default: "", null: false
  end

  add_index "InteractsWith", ["iBrandName", "iGenericName"], name: "iBrandName", using: :btree

  create_table "MakesAppointmentWith", id: false, force: :cascade do |t|
    t.time   "TimeMade"
    t.date   "DateMade"
    t.string "LicenseNum",    limit: 10, default: "",                    null: false
    t.date   "TimeBlockDate",                                            null: false
    t.time   "StartTime",                default: '2000-01-01 00:00:00', null: false
    t.time   "EndTime",                  default: '2000-01-01 00:00:00', null: false
    t.string "CareCardNum",   limit: 10
  end

  add_index "MakesAppointmentWith", ["CareCardNum"], name: "CareCardNum", using: :btree
  add_index "MakesAppointmentWith", ["TimeBlockDate", "StartTime", "EndTime"], name: "TimeBlockDate", using: :btree

  create_table "OrderedFrom", id: false, force: :cascade do |t|
    t.string "PrescriptID",     limit: 4,  default: "", null: false
    t.string "PharmacyAddress", limit: 50, default: "", null: false
    t.string "OrderNo",         limit: 11
  end

  add_index "OrderedFrom", ["OrderNo"], name: "OrderNo", unique: true, using: :btree
  add_index "OrderedFrom", ["PharmacyAddress"], name: "PharmacyAddress", using: :btree

  create_table "Patient", primary_key: "CareCardNum", force: :cascade do |t|
    t.string  "FirstName",   limit: 20
    t.string  "LastName",    limit: 20
    t.integer "Age",         limit: 4
    t.integer "Weight",      limit: 4
    t.integer "Height",      limit: 4
    t.string  "Address",     limit: 50
    t.string  "PhoneNumber", limit: 10
  end

  add_index "Patient", ["Address", "FirstName", "LastName"], name: "Address", unique: true, using: :btree

  create_table "Pharmacy", primary_key: "Address", force: :cascade do |t|
    t.string "Name",                limit: 40
    t.string "PhoneNumber",         limit: 10
    t.time   "WeekdayHoursOpening"
    t.time   "WeekdayHoursClosing"
    t.time   "WeekendHoursOpening"
    t.time   "WeekendHoursClosing"
  end

  add_index "Pharmacy", ["PhoneNumber"], name: "PhoneNumber", unique: true, using: :btree

  create_table "Prescription", primary_key: "PrescriptID", force: :cascade do |t|
    t.string  "LicenseNum",      limit: 10
    t.integer "Refills",         limit: 4
    t.string  "Dosage",          limit: 50
    t.string  "CareCardNum",     limit: 10
    t.boolean "ReadyForPickUp",  limit: 1
    t.date    "date_prescribed"
  end

  add_index "Prescription", ["CareCardNum"], name: "CareCardNum", using: :btree
  add_index "Prescription", ["LicenseNum"], name: "LicenseNum", using: :btree

  create_table "TimeBlock", id: false, force: :cascade do |t|
    t.date "TimeBlockDate",                                 null: false
    t.time "StartTime",     default: '2000-01-01 00:00:00', null: false
    t.time "EndTime",       default: '2000-01-01 00:00:00', null: false
  end

  create_table "tables", force: :cascade do |t|
    t.string   "var1",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "identity",   limit: 4
=======
  create_table "drug", id: false, force: :cascade do |t|
    t.string  "brand_name",   limit: 30
    t.string  "generic_name", limit: 30
    t.string  "company_name", limit: 30
    t.integer "price",        limit: 4
  end

  create_table "prescription", id: false, force: :cascade do |t|
    t.integer "id",           limit: 4
    t.string  "generic_name", limit: 30
>>>>>>> d7350094fe538c2d1e368a7eae759bdadb9ef22e
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "license_num",            limit: 255
    t.string   "care_card_num",          limit: 255
    t.string   "pharmacy_address",       limit: 255
    t.string   "user_type",              limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "views", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "views", ["email"], name: "index_views_on_email", unique: true, using: :btree
  add_index "views", ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "Includes", "Drug", column: "BrandName", primary_key: "BrandName", name: "Includes_ibfk_2"
  add_foreign_key "Includes", "Drug", column: "GenericName", primary_key: "GenericName", name: "Includes_ibfk_2"
  add_foreign_key "Includes", "Prescription", column: "PrescriptID", primary_key: "PrescriptID", name: "Includes_ibfk_1"
  add_foreign_key "InteractsWith", "Drug", column: "dBrandName", primary_key: "BrandName", name: "InteractsWith_ibfk_1", on_delete: :cascade
  add_foreign_key "InteractsWith", "Drug", column: "dGenericName", primary_key: "GenericName", name: "InteractsWith_ibfk_1", on_delete: :cascade
  add_foreign_key "InteractsWith", "Drug", column: "iBrandName", primary_key: "BrandName", name: "InteractsWith_ibfk_2", on_delete: :cascade
  add_foreign_key "InteractsWith", "Drug", column: "iGenericName", primary_key: "GenericName", name: "InteractsWith_ibfk_2", on_delete: :cascade
  add_foreign_key "MakesAppointmentWith", "Doctor", column: "LicenseNum", primary_key: "LicenseNum", name: "MakesAppointmentWith_ibfk_1"
  add_foreign_key "MakesAppointmentWith", "Patient", column: "CareCardNum", primary_key: "CareCardNum", name: "MakesAppointmentWith_ibfk_3"
  add_foreign_key "MakesAppointmentWith", "TimeBlock", column: "EndTime", primary_key: "EndTime", name: "MakesAppointmentWith_ibfk_2"
  add_foreign_key "MakesAppointmentWith", "TimeBlock", column: "StartTime", primary_key: "StartTime", name: "MakesAppointmentWith_ibfk_2"
  add_foreign_key "MakesAppointmentWith", "TimeBlock", column: "TimeBlockDate", primary_key: "TimeBlockDate", name: "MakesAppointmentWith_ibfk_2"
  add_foreign_key "OrderedFrom", "Pharmacy", column: "PharmacyAddress", primary_key: "Address", name: "OrderedFrom_ibfk_2", on_delete: :cascade
  add_foreign_key "OrderedFrom", "Prescription", column: "PrescriptID", primary_key: "PrescriptID", name: "OrderedFrom_ibfk_1", on_delete: :cascade
  add_foreign_key "Prescription", "Doctor", column: "LicenseNum", primary_key: "LicenseNum", name: "Prescription_ibfk_1"
  add_foreign_key "Prescription", "Patient", column: "CareCardNum", primary_key: "CareCardNum", name: "Prescription_ibfk_2", on_delete: :cascade
end
