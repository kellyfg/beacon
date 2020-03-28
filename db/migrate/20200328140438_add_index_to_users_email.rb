class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :users, :email, :unique => true, algorithm: :concurrently
  end
end
