class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
  has_many :pending_friendships, -> { where(confirmed: false) }, class_name: 'Friendship', dependent: :destroy
  has_many :confirmed_friendships, -> { where(confirmed: true) }, class_name: 'Friendship', dependent: :destroy
  has_many :friendship_requests, -> { where(confirmed: false) }, foreign_key: 'friend_id', class_name: 'Friendship', dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :find_user, ->(user = false) { find(user) }

  # TODO: change method to use scopes
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
    if friendship
      friendship.confirmed = true
      friendship.save
      true
    else
      false
    end
  end

  # TODO: make friends? and semifriends? to work
  def friends?(possible_friend)
    return false if confirmed_friendships.empty?

    confirmed_friendships.find_friendship(self, possible_friend) ? true : false
  end

  def semifriends?(possible_friend)
    return false if pending_friendships.empty?

    pending_friendships.find_friendship(self, possible_friend) || pending_friendships.find_friendship(possible_friend, self) ? true : false
  end
end
