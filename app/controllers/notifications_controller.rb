class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @notifications = current_user.notifications
    respond_to do |format|
      format.html { render :index } 
      format.json { render json: @notifications }
    end
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.update!(read: true)
    redirect_to job_path(@notification.job)
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    if @notification.update(read: true)
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
end
