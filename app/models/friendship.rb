class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :find_friendship, ->(friend = false) { find_by(friend_id: friend.id) }

  def self.make_friends(friend); end

end
