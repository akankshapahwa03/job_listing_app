class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :job
  validates :user_id, uniqueness: { scope: :job_id, message: "This job has already been shared with this user." }

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
end
