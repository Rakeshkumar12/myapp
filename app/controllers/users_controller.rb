class UsersController < ApplicationController

  before_action :authenticate_user!

  before_action :admin_user, only: :destroy

  def index
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").paginate(page: params[:page], :per_page => 10)
    else
     @users = User.where.not("id = ?",current_user.id).order("created_at DESC").paginate(page: params[:page], :per_page => 10)
     @conversations = Conversation.involving(current_user).order("created_at DESC")
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => 20)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'User Deleted'
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page], :per_page => 10)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], :per_page => 10)
    render 'show_follow'
  end

  private

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
