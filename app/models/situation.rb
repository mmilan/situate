class Situation < ApplicationRecord
  belongs_to :user

  has_many :situation_tags, dependent: :destroy
  has_many :tags, through: :situation_tags

  # Visibility levels: public (anyone), followers (only followers), private (only self)
  enum :visibility, { public_visibility: 0, followers_only: 1, private_visibility: 2 }, default: :public_visibility

  validates :visibility, presence: true

  # Scope for feed - situations visible to a specific user
  scope :visible_to, ->(viewer) {
    if viewer.nil?
      where(visibility: :public_visibility)
    else
      where(visibility: :public_visibility)
        .or(where(visibility: :followers_only, user: viewer.following))
        .or(where(user: viewer))
    end
  }

  # Format tags for display
  def tags_display
    tags.map { |t| "<#{t.name}>" }.join(" ")
  end
end
