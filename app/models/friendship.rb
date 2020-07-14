class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :find_friendship, ->(user = nil, friend = nil) { find_by(user_id: user, friend_id: friend) }

  def self.make_friends(friend); end

end
