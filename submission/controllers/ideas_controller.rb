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
