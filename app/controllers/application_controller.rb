class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  include SessionsHelper

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".logged_in_user.please_log_in"
    redirect_to login_path
  end
end
