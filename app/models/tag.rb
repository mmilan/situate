class Tag < ApplicationRecord
  belongs_to :user

  has_many :situation_tags, dependent: :destroy
  has_many :situations, through: :situation_tags

  # Categories: location, activity, availability, contact, custom
  CATEGORIES = %w[location activity availability contact custom].freeze

  validates :name, presence: true, length: { maximum: 50 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  # Normalize tag name
  normalizes :name, with: ->(n) { n.strip.downcase.gsub(/\s+/, "_") }

  scope :by_category, ->(category) { where(category: category) }
end
