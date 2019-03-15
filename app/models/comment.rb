class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  has_many :likes, as: :likeable
  has_many :likers, through: :likes, source: :user
  validates :user_id, presence: true
  validates :micropost_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
