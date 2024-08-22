class UserMailer < ApplicationMailer
  def send_otp(user)
    @user = user
    mail(to: @user.email, subject: "OTP for Verification")
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Job Listing App")
  end
end
