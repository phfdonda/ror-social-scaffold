module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def add_friend(user)
    friendship = Friendship.find_by(user_id: current_user.id, friend_id: user.id)
    if user.friend?(current_user)
      link_to('Dismiss Friendship', user_friendship_path(id: friendship.id, post_id: post.id), method: :delete)
    else
      link_to('Request Friendship', user_friendships_path(user_id: current_user, friend_id: user.id), method: :post)
    end
  end

  def pending_invitations
    current_user.pending_friendships
  end

  def pending_requests
    current_user.friendship_requests
  end
end
