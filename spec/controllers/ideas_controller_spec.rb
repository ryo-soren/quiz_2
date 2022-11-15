require 'rails_helper'

RSpec.describe IdeasController, type: :controller do   
    describe "#new" do

        context "with signed in user" do
            
            before do
                session[:user_id] = FactoryBot.create(:user).id
            end     
            it "requires a render of a new template" do
                get(:new)
                expect(response).to(render_template(:new))
            end
        end

        context "without signed in user" do
            it "requires redirect to the sign in page" do 
                get(:new)
                expect(response).to(redirect_to(new_session_path))
            end
        end
    end
  

    describe "#create" do

        context "with valid parameters" do

            before do
                session[:user_id] = FactoryBot.create(:user).id
            end   
            
            context "with valid parameters" do
                it "requires a new creation of a idea post in the database" do
                    count_before = Idea.count
                    idea = FactoryBot.create(:idea)
                    count_after = Idea.count
                    expect(count_after).to(eq(count_before + 1))
                end

                it "it requires a redirect to the show page" do
                    valid_idea = post(:create, params:{
                        idea: FactoryBot.attributes_for(:idea)
                    })
                    last_idea = Idea.last
                    expect(response).to(redirect_to(last_idea))
                end
            end

            context "with invalid parameters" do
                it "requires the database not save the new record" do
                    count_before = Idea.count
                    invalid_idea = FactoryBot.attributes_for(:idea, title: nil)
                    count_after = Idea.count
                    expect(count_after).to(eq(count_before))
                end

                it "it requires a render to the new page" do
                    valid_idea = post(:create, params:{
                        idea: FactoryBot.attributes_for(:idea, title: nil)
                    })
                    last_idea = Idea.last
                    expect(response).to(render_template(:new))
                end
            end
        end
    end
end
