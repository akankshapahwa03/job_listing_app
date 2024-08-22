class SendOtpJob < ApplicationJob
  queue_as :default

  def perform(user)
    UserMailer.send_otp(user).deliver_now
  end
end