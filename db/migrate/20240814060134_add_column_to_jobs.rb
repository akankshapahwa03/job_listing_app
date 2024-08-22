class AddColumnToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :draft, :boolean, default: false
  end
end
