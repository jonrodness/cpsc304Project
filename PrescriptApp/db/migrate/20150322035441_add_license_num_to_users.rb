class AddLicenseNumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :license_num, :string
    add_column :users, :care_card_num, :string
    add_column :users, :pharmacy_address, :string
    add_column :users, :user_type, :string
  end
end
