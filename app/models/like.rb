class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: :post_id }

  belongs_to :user
  belongs_to :post

  def self.find_like(like, user, post)
    find_by(id: like, user: user, post_id: post)
  end
end
