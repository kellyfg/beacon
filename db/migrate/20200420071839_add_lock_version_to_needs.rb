class AddLockVersionToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :lock_version, :integer, default: 0
  end
end
