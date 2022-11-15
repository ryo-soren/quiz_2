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
