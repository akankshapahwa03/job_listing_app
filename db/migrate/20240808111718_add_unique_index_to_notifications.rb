class AddUniqueIndexToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_index :notifications, [:user_id, :job_id], unique: true 
  end
end
