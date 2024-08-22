class PagesController < ApplicationController
  before_action :authenticate_user!
  def home
    @jobs = current_user.jobs
  end
end
