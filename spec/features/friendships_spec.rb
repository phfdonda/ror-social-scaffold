require 'rails_helper'

RSpec.feature 'Friendship' do
  let!(:user) { create(:random_user) }
  let!(:friend) { create(:random_friend) }

  context 'User add a friend' do

    it 'friend request is created' do
      friend
      login_user(user)
      visit user_path(id: friend.id)
      click_link 'Request Friendship'
      sleep(3)
      expect(page).to have_content('You sent a friend request!')
    end

    it 'two objects are created when you send a friend request' do
      click_link 'Request Friendship'
      friendship = Friendship.last
      friendship_two = Friendship.first
      expect(friendship.id).to eql(friendship_two.id + 1)
    end

    it 'friend request is accepted' do
      Friendship.update
      expect(Frienship.confirmed).to eql(true)
    end

    it 'friend request is rejected' do
      expect(Friendship.confirmed).to eql(false)
    end

    it 'two objects are update when you accept a friend request' do
      Friendship.update
      friendship = user.friendships.where(friend_id: friend.id)
      inverse_friendship = friend.friendships.where(friend_id: user.id)
      expect(friendship.confirmed).to eql(inverse_friendship.confirmed)
    end
  end
end
