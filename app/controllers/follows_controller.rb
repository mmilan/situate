class FollowsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    Current.user.follow(@user)
    redirect_back fallback_location: user_path(@user.username), notice: "You are now following @#{@user.username}"
  end

  def destroy
    @follow = Current.user.active_follows.find(params[:id])
    @user = @follow.followed
    @follow.destroy
    redirect_back fallback_location: user_path(@user.username), notice: "You have unfollowed @#{@user.username}"
  end
end
