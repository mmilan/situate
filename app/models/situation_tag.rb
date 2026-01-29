class SituationTag < ApplicationRecord
  belongs_to :situation
  belongs_to :tag
end
