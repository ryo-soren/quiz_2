class ApplicationController < ActionController::Base
    def current_user
        @current_user ||= User.find_by_id session[:user_id]
    end

    helper_method :current_user

    def user_signed_in?
        current_user.present?
    end

    helper_method :user_signed_in?

    def authenticate_user!
        redirect_to new_session_path, notice: "Please sign in" unless user_signed_in?
    end

end

class IdeasController < ApplicationController
    before_action :find_idea, only:[:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only:[:new, :create, :edit, :destroy]

    def new
        @idea = Idea.new
    end

    def create
        @idea = Idea.new(idea_params)
        @idea.user = current_user
        if @idea.save
            redirect_to @idea, alert: "Idea created" 
        else
            render 'new', alert: "Something went wrong"
        end
    end

    def show
        @reviews = @idea.reviews.order(created_at: :desc)
        @review = Review.new
    end

    def index
        @ideas = Idea.order(created_at: :desc)

    end

    def edit
        if can?(:crud, @idea)
            render :edit
        end
    end

    def update
        if @idea.update(idea_params)
            redirect_to @idea, alert: "Idea updated"
        else
            render :edit
        end
    end

    def destroy
        if can?(:crud, @idea)
            @idea.destroy
            redirect_to ideas_path, alert: "Idea deleted"
        else
            redirect_to @idea, alert: "Not authorized to make changes"
        end
    end

    private

    def find_idea
        @idea = Idea.find params[:id]
    end

    def idea_params
        params.require(:idea).permit(:title, :body)
    end
end

class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_idea, only:[:destroy]

    def create
        @idea = Idea.find params[:idea_id]
        @like = Like.new(idea: @idea, user: current_user)
        if can?(:like, @idea)
            @like.save
            flash.notice = "Question liked"
        else
            flash.alert = "Something went wrong"
        end
        redirect_to idea_path(@like.idea_id)
    end

    def destroy
        @like = current_user.likes.find_by_idea_id(@idea.id)
        if can?(:destroy, @like)
            @like.destroy
            flash.notice = "Question Unliked"
        else
            flash.alert = @like.errors.full_messages.join(", ")
        end
        redirect_to idea_path(@idea)
    end

    private 

    def find_idea
        @idea = Idea.find params[:id]
    end
end

class ReviewsController < ApplicationController
    before_action :find_idea
    before_action :authenticate_user!


    def create
        @review = Review.new(review_params)
        @review.idea_id = @idea.id
        @review.user = current_user

        if can?(:crud, @review) 
            @review.save
            redirect_to idea_path(@idea.id), alert: "review created"
        else
            render 'reviews/show', stats: 303
        end
    end

    def destroy
        @review = Review.find params[:id]
        if can?(:crud, @review)
            @review.destroy
            redirect_to idea_path(@idea.id), alert: "review deleted"
        else
            redirect_to @idea, alert: "Not authorized to make changes"
        end
    end

    private

    def review_params
        params.require(:review).permit(:body)
    end

    def find_idea
        @idea = Review.find params[:idea_id]
    end
end

class SessionsController < ApplicationController
    def new
    end

    def create
        @user = User.find_by_email params[:email]
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect_to root_path, {notice: "Signed in"}
        else
            render :new, {alert: "Wrong email or password!", status: 303}
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "Signed out!"
    end
end

class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id
            redirect_to root_path, alert: "Signed up successfully"
        else
            render :new, status: 303
        end
    end

    private

    def user_params
        params.require(:user).permit(:first_name, 
        :last_name, 
        :email, 
        :password, 
        :password_confirmation
        )
    end
end

