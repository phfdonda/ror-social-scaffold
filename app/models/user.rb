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

  def friends
    friends_array = confirmed_friendships.to_a
    friends_array += inverse_friendships.to_a
    friends_array.compact
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
    check_confirmed?(self, possible_friend) || check_confirmed?(possible_friend, self) ? true : false
  end

  def semifriends?(possible_friend)
    check_pending?(self, possible_friend) || check_request?(possible_friend, self) ? true : false
  end

  private

  # Returns true if user1 has pending frienship with user2, else false
  def check_pending?(user1, user2)
    return false if pending_friendships.empty?

    return true if pending_friendships.find_friendship(user1, user2)
  end

  # Returns true if user1 requested frienship with user2, else false
  def check_request?(user1, user2)
    return false if friendship_requests.empty?

    return true if friendship_requests.find_friendship(user1, user2)
  end

  # Returns true if user1 has a confirmed friendship with user2, else false
  def check_confirmed?(user1, user2)
    return false if confirmed_friendships.empty?

    return true if confirmed_friendships.find_friendship(user1, user2)
  end
end
