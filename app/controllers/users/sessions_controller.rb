class Users::SessionsController < Devise::SessionsController

  def create
    self.resource = User.find_by(email: params[:user][:email])
    if resource && resource.valid_password?(params[:user][:password])
      if resource.admin?
        sign_in(resource)
        redirect_to after_sign_in_path_for(resource)
      else
        resource.generate_otp
        SendOtpJob.perform_later(resource)
        flash[:notice] = "OTP sent to your email successfully"
        redirect_to users_verify_otp_path(email: resource.email)
      end
    else
      flash[:alert] = "Invalid email or password"
      redirect_to new_user_session_path
    end
  end
  
  def verify_otp
    @user = User.find_by(email: params[:email])

    if request.get?
      if @user.nil?
        flash[:alert] = "User not found"
        redirect_to new_user_session_path
      else
        render :verify_otp
      end
    elsif request.post?
      if @user.otp_valid?(params[:otp])
         @user.clear_otp
         sign_in(@user)
         redirect_to after_sign_in_path_for(@user)
         flash[:notice] = "Logged in successfully"
      else 
        flash.now[:alert] = "Invalid OTP"
        Rails.logger.debug " #{flash[:alert]}"
        render :verify_otp
      end
    end
  end

  def resend_otp
    @user = User.find_by(email: params[:email])
    @user.generate_otp
    SendOtpJob.perform_later(resource)
    flash[:notice] = "OTP resent successfully"
    redirect_to users_verify_otp_path(email: resource.email)
  end
end
