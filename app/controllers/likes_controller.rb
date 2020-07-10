class LikesController < ApplicationController
  def create
    @like = current_user.likes.new(post_id: params[:post_id])
    redirect_to posts_path, notice: 'You liked a post.' if @like.save
  end

  def destroy
    like = Like.find_like(params[:id], current_user, params[:post_id])
    like&.destroy
    redirect_to posts_path, notice: 'You disliked a post.'
  end
end
