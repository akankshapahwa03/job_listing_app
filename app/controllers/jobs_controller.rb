class JobsController < ApplicationController
  before_action :set_employment_types
  before_action :set_industries

  def index
    @search = Job.search do
      fulltext params[:search] if params[:search].present?
      if params[:employment_type_id].present?
        case params[:employment_type_id]
        when 'full_time'
          with(:employment_type_id, 1)
        when 'part_time'
          with(:employment_type_id, 2)
        when 'contract'
          with(:employment_type_id, 3)
        end
      end
      if params[:industry_id].present?
        case params[:industry_id]
        when 'information_technology_it'
          with(:industry_id, 1)
        when 'accounting'
          with(:industry_id, 2)
        when 'human_resources_hr'
          with(:industry_id, 3)
        when 'healthcare'
          with(:industry_id, 4) 
        when 'education'
          with(:industry_id, 5) 
        end
      end
    end
    @search_results = @search.results
    if current_user.admin?
      @published_jobs = Job.published.where(id: @search_results.map(&:id))
    else 
      @notifications = current_user.notifications
      @published_jobs = current_user.jobs.published
    end
  end

  def show
    @job = Job.find(params[:id])
    @user = @job.user
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    
    if params[:draft].present?
      @job.draft = true
      if @job.save(validate: false)
        redirect_to edit_job_path(@job), notice: "Draft saved successfully"
      else
        render :new, alert: "Failed to save draft"
      end
    else
      @job.draft = false
      if @job.save
        redirect_to @job, notice: "Job published successfully"
      else
        render :new
      end
    end
  end
  

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    @job.draft = params[:commit] == 'draft'

    if @job.update(job_params)
      if @job.draft?
        redirect_to edit_job_path(@job), notice: "Draft saved successfully"
      else
        redirect_to @job, notice: "Job updated successfully"
      end
    else
      render :edit
    end
  end

  def share
    @job = Job.find(params[:id])
    @sender = current_user
    @recipient = User.find_by(id: params[:user_id])
  
    if @recipient.nil?
      flash[:alert] = "Please select a user to share the job with."
      redirect_to jobs_path
    else
      existing_notification = @recipient.notifications.find_by(job: @job)
      
      if existing_notification
        flash[:alert] = "This job has already been shared with this user."
        redirect_to @job
      else
        notification = @recipient.notifications.create(
          job: @job,
          message: "#{@sender.name} shared a job with you."
        )
        if notification.persisted?
          # Broadcast the notification
          ActionCable.server.broadcast("notification_channel", {
            id: notification.id,
            message: notification.message,
            link: job_path(@job)
          })
          flash[:notice] = "Job shared successfully!"
          redirect_to @job
        else
          flash[:alert] = "Job could not be shared."
          redirect_to @job
        end
      end
    end
  end

  def draft
    if !current_user.admin?
    @drafts = current_user.jobs.drafts
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to root_path
    flash[:alert] = "Job deleted successfully"
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :employment_type_id, :industry_id, :user_id, :draft)
  end

  def set_employment_types
    @employment_types = EmploymentType.all
  end

  def set_industries
    @industries = Industry.all
  end
end
