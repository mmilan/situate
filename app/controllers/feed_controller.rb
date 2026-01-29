class FeedController < ApplicationController
  allow_unauthenticated_access

  def index
    if authenticated?
      # Show situations from followed users + own situations
      following_ids = Current.user.following.pluck(:id) << Current.user.id
      @situations = Situation.where(user_id: following_ids)
                             .visible_to(Current.user)
                             .includes(:user, :tags)
                             .order(created_at: :desc)
                             .limit(50)
      @situation = Situation.new
      @tags = Current.user.tags.order(:category, :name)
    else
      # Show public situations for non-logged-in users
      @situations = Situation.public_visibility
                             .includes(:user, :tags)
                             .order(created_at: :desc)
                             .limit(20)
    end
  end
end
