class ApplicationController < ActionController::Base
  # after_action :flash_devise_errors, if: -> { devise_controller? && resource&.errors&.any? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: %i[image name role])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[image name])
  end
end
