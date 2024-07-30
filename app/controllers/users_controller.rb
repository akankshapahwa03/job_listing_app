class UsersController < ApplicationController
  before_action :authenticate_user! 
  def show
    @user = User.find(params[:id])
    Rails.logger.debug "User ID: #{@user.id}"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end
  private

  def user_params
    params.require(:user).permit(:id, :name, :email, :password, :password_confirmation)
  end
end
