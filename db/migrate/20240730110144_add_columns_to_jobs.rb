class AddColumnsToJobs < ActiveRecord::Migration[7.1]
  def change
    add_reference :jobs, :employment_type, null: true, foreign_key: true
    add_reference :jobs, :industry, null: true, foreign_key: true
  end
end
