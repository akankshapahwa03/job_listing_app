class Job < ApplicationRecord
  belongs_to :user
  belongs_to :employment_type, optional: true
  belongs_to :industry, optional: true
  has_many :notifications, dependent: :destroy

  with_options unless: :draft? do
    validates :title, :description, :employment_type_id, :industry_id, presence: true
  end
  
 
  scope :drafts, -> { where(draft: true) }
  scope :published, -> { where(draft: false) }
 
  searchable do
    text :title, :description
    integer :employment_type_id
    integer :industry_id
  end

  def draft?
    draft
  end
end
