class Friendship < ApplicationRecord
  before_create :prevent_duplication, on: :create

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :find_friendship, ->(user = nil, friend = nil) { find_by(user_id: user, friend_id: friend) }

  def prevent_duplication
    friend = User.find_user(friend_id)
    return unless user.friends?(friend) || user.semifriends?(friend)

    raise ActiveRecord::RecordInvalid
  end
end
