class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Password reset token (expires in 15 minutes)
  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  # Situations (status updates)
  has_many :situations, dependent: :destroy

  # Tags created by this user
  has_many :tags, dependent: :destroy

  # Following relationships
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :username, with: ->(u) { u.strip.downcase }

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 },
            format: { with: /\A[a-z0-9_]+\z/, message: "only allows lowercase letters, numbers, and underscores" }

  # Get the user's current situation (most recent)
  def current_situation
    situations.order(created_at: :desc).first
  end

  # Check if following another user
  def following?(other_user)
    following.include?(other_user)
  end

  # Follow another user
  def follow(other_user)
    following << other_user unless self == other_user || following?(other_user)
  end

  # Unfollow a user
  def unfollow(other_user)
    following.delete(other_user)
  end
end
