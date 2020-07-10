class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  has_many :friendships
  has_many
  has_many :pending_friendships, -> { where(confirmed: false) }, class_name: 'Friendship'
  has_many :confirmed_friendships, -> { where(confirmed: true) }, class_name: 'Friendship'
  has_many :friendship_requests, -> { where(friend_id: :id) }, class_name: 'Friendship'
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def self.find_user(id)
    find(id)
  end

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array += inverse_friendships.map { |friendship| friendship.friendship.user if friendship.confirmed }
    friends_array.compact
  end

  # TODO: !!! FIX THIS
  def friend_requests
    friendship_requests.pending_friendships
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |f| f.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end

  def self.are_friends?(possible_friend)
    Friendship.find(user_id: :id, friend_id: possible_friend.id, confirmed: true) ? true : false
  end

  def self.are_semifriends?(possible_friend)
    Friendship.find(user_id: :id, friend_id: possible_friend.id, confirmed: false) ? true : false
  end
end
