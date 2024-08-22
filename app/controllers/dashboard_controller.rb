class DashboardController < ApplicationController
  before_action :check_if_admin?
  def index
    @search = User.search do
      fulltext params[:search] if params[:search].present?

      if params[:created_at].present?
        case params[:created_at]
        when 'today'
          with(:created_at).between(Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        when 'yesterday'
          with(:created_at).between(Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
        when 'last_week'
          with(:created_at).greater_than(7.days.ago)
        when 'last_month'
          with(:created_at).greater_than(30.days.ago)
        when 'last_3_months'
          with(:created_at).greater_than(3.months.ago)
        end
      end
      if params[:role].present?
        case params[:role]
        when 'admin'
          with(:role, 'admin')
        when 'member'
          with(:role, 'member')
        end
      end
      order_by :created_at, :desc
    end
    
    @users = @search.results
    @jobs = Job.all
    @employment_types = EmploymentType.all
    @industries = Industry.all
  end
  

  private
  def check_if_admin?
    unless current_user&.admin?
      flash[:alert] = "Access Denied"
      redirect_to root_path
    end
  end
end
