class UsersController < ApplicationController
  before_action :authenticate_user! 
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'
      redirect_to @user
    else
      flash[:danger] = "Could not be updated"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:alert] = "User deleted"
    redirect_to dashboard_path
  end
  
  private

  def user_params
    params.require(:user).permit(:id, :image, :name, :email, :password, :password_confirmation)
  end
end
