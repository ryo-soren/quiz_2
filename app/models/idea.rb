class Idea < ApplicationRecord
    has_many :reviews, dependent: :destroy
    
    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes, source: :user

    belongs_to :user

    validates :title, presence: true
    validates :body, presence: true
end
