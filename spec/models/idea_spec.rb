require 'rails_helper'

RSpec.describe Idea, type: :model do

  describe "validation" do
    describe "title" do
      it "requires a title to be present" do
        idea = FactoryBot.build(:idea, title: nil)
        idea.valid?
        expect(idea.errors.messages).to(have_key(:title))
      end
    end

    describe "body" do
      it "requires a body to be present" do
        idea = FactoryBot.build(:idea, body: nil)
        idea.valid?
        expect(idea.errors.messages).to(have_key(:body))
      end
    end
  end
end
