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
