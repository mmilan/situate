class UsersController < ApplicationController
  allow_unauthenticated_access

  def show
    @user = User.find_by!(username: params[:username])
    @situations = @user.situations
                       .visible_to(Current.user)
                       .includes(:tags)
                       .order(created_at: :desc)
                       .limit(20)
    @current_situation = @user.current_situation
  end
end
