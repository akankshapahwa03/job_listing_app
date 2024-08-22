class User < ApplicationRecord
  
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable
  has_one_attached :image
  has_many :jobs,  -> { order(created_at: :desc) }
  has_many :notifications, -> { order(created_at: :desc) }, dependent: :destroy
  enum role: %i[admin member]
  validates :name, presence: true
  validate :image_content_type
  validate :image_size
  validates :role, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
     
  def display_image
    image.variant(resize_to_limit: [100, 100])
  end

  def generate_otp
    self.otp_secret = rand.to_s[2..7]
    self.otp_sent_at = Time.current
    save!
  end

  def resend_otp
    self.generate_otp
  end

  def otp_valid?(entered_otp)
  #   Rails.logger.debug "Validating OTP: #{otp_secret} against entered OTP: #{entered_otp}"
  # Rails.logger.debug "OTP sent at: #{otp_sent_at}, current time: #{Time.current}"
    otp_secret == entered_otp && otp_sent_at > 10.minutes.ago
  end

  def clear_otp
    self.otp_secret = nil
    self.otp_sent_at = nil
    save!
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  searchable do
    text :name, :email
    time :created_at
    string :role
  end
  
  private


  def image_content_type
    if image.attached?
      # Rails.logger.debug "Uploaded image content type: #{image.content_type}"
      unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
        errors.add(:image, "Only jpeg, jpg, png or gif formats allowed")
      end
    end
  end
  
  def image_size
    if image.attached?
      if image.blob.byte_size > 2.megabytes
        errors.add(:image, "Image should be less than 2MB")
      end
    end
  end
end