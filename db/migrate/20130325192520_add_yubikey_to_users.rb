class AddYubikeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :use_yubikey, :boolean
    add_column :users, :registered_yubikey, :string
  end
end
