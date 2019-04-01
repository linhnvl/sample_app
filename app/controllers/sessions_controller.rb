class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] ==
        Settings.app.sessions_controllers.yes_remember_me ?
        remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = t ".password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to :root
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash[:danger] = t ".email"
    render :new
  end
end
