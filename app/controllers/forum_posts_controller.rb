class ForumPostsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]

    def create
        @threads = ForumThread.friendly.find(params[:forum_thread_id])
        @posts = ForumPost.new(resource_params)

        @posts.forum_thread = @threads
        @posts.user = current_user

        if @posts.save
            redirect_to forum_thread_path(@threads)
        else
            render 'forum_threads/show'
        end
    end

    private
    def resource_params
        params.require(:forum_post).permit(:content)
    end

end