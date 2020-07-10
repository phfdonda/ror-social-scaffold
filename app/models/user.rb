class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :pending_friendships, -> { where(confirmed: false) }, class_name: 'Friendship'
  has_many :confirmed_friendships, -> { where(confirmed: true) }, class_name: 'Friendship'
  has_many :friendship_requests, -> { where(confirmed: false) }, foreign_key: 'friend_id', class_name: 'Friendship'
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :find_user, ->(user = false) { find(user) }


  # def self.find_user(id)
  #   find(id)
  # end

  def friends
    friends_array = confirmed_friendships
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

  def friends?(possible_friend)
    return false if confirmed_friendships.nil?

    confirmed_friendships.find_friendship(possible_friend) ? true : false
  end

  def semifriends?(possible_friend)
    return false if pending_friendships.nil?

    pending_friendships.find_friendship(possible_friend) ? true : false
  end
end
