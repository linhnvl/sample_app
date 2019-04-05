class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.app.per_page
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.app.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".create.flash_info"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update.flash_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".destroy.flash_success"
    else
      flash[:danger] = t ".destroy.flash_danger"
    end
    redirect_to users_path
  end

  def following
    @title = t ".following.following_title"
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t ".followers.followers_title"
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".load_user.flash_danger"
    redirect_to :root
  end

  # Confirms the correct user.
  def correct_user
    redirect_to root_path unless current_user? @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
