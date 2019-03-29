class SessionsController < ApplicationController
  before_action :load_user, :remember_me?, only: :create

  def new; end

  def create
    if @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        redirect_back_or @user
      else
        message = t ".message1"
        message += t ".message2"
        flash[:warning] = message
        redirect_to root_path
      end
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

  def remember_me?
    yes_remember = Settings.app.yes_remember_me
    session_remember_me = params[:session][:remember_me] == yes_remember
    if session_remember_me
      remember @user
    else
      forget @user
    end
  end
end
