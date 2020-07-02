require 'rails_helper'

RSpec.describe 'User' do
  let(:frienship_send) { Friendship.create(user_id: 1, friend_id: 2, confirmed: false) }

  context 'doesn\'t exist' do
    let(:user_params) { { name: 'Tester', email: 'test@testing.com', password: '123456'} }
    let(:long_name) { 'a' * 25 }

    it 'can create a new user' do
      User.create(user_params)
      expect(User.last).to be_present
    end

    it 'can\'t create a new user due to not password' do
      User.create(user_params.merge(password: nil))
      expect(User.last).to_not be_present
    end

    it 'can\'t create a new user due to short password' do
      User.create(user_params.merge(password: '123'))
      expect(User.last).to_not be_present
    end

    it 'can\'t create a new user due to long name' do
      User.create(user_params.merge(name: long_name))
      expect(User.last).to_not be_present
    end
  end

  # context 'user already exist' do
  #   user1 = User.create(user_params)
  #   user2 = User.create()
  #   user3 = User.create()
  #   user4 = User.create()
  #
  #   it 'can send friendship request' do
  #     expect
  #   end
  #
  #   it 'can check pending friends' do
  #     expect
  #   end
  #
  #   it 'can check friend requests' do
  #     expect
  #   end
  #
  #   it 'can check friends' do
  #     expect
  #   end
  #
  #   it 'can check if a user is a friend' do
  #     expect
  #   end
  #
  #   it 'can confirm friends' do
  #     expect
  #   end

  # end
end