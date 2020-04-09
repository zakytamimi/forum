class ForumThreadsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]

    def index
        if params[:search]
            @threads = ForumThread.where('title like ?', "%#{params[:search]}%").paginate(per_page: 5, page: params[:page])
        else
            @threads = ForumThread.order(sticky_order: :asc).order(id: :desc).paginate(per_page: 5, page: params[:page])
        end        
    end

    def show
        @threads = ForumThread.friendly.find(params[:id])
        @posts = ForumPost.new
        @post = @threads.forum_posts.paginate(per_page: 3, page: params[:page])
    end

    def new
        @threads = ForumThread.new
    end

    def create
        @threads = ForumThread.new(resource_params)
        @threads.user = current_user
        if @threads.save
            redirect_to root_path
        else
            render 'new'
        end
    end

    def edit
        @threads = ForumThread.friendly.find(params[:id])
        authorize @threads
    end

    def destroy
        @threads = ForumThread.friendly.find(params[:id])
        authorize @threads

        @threads.destroy

        redirect_to root_path, notice: 'Thread telah di hapus'
    end

    def update
        @threads = ForumThread.friendly.find(params[:id])
        authorize @threads

        if @threads.update(resource_params)
            redirect_to forum_thread_path(@threads)
        else
            render 'new'
        end
    end

    def pinit
        @threads = ForumThread.friendly.find(params[:id])
        @threads.pinit #ini untuk perintah ketika klik button maka dilakukan pin.
        redirect_to root_path
    end

    private
    def resource_params
        params.require(:forum_thread).permit(:title, :content)
    end
end