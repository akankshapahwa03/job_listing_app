class Users::InvitationsController < Devise::InvitationsController
  before_action :authenticate_inviter!, only: %i[new create]

  def update
    super do |resource|
      if resource.persisted?
        WelcomeEmailJob.perform_later(resource)
      end
    end
  end
  
  # def update
  #   super do |resource|
  #       if resource.admin?
  #         flash[:notice] = "Invitation accepted. Admins do not require OTP verification."
  #         redirect_to after_sign_in_path_for(resource)
  #       else
  #         resource.generate_otp
  #         UserMailer.send_otp(resource).deliver_now
  #         flash[:notice] = "OTP sent to your email successfully"
  #         redirect_to users_verify_otp_path(email: resource.email)
  #       end
  #     end
  #   end
 
  private

  def authenticate_inviter!
    unless current_user&.admin?
      flash[:alert] = "Access Denied"
      redirect_to root_url
    end
    super
  end
end
