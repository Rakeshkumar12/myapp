class MicropostsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :currect_user, only: :destroy

  def create
    @micropost = current_user.microposts.create(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created'
      redirect_to root_url
    else
      @feed_items = []
      render 'home_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def currect_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

end
