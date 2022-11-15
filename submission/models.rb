# frozen_string_literal: true

class Ability
    include CanCan::Ability
  
    def initialize(user)
      user ||= User.new
  
      alias_action :create, :read, :update, :delete, :to => :crud
  
      can :crud, Idea do |idea|
        user == idea.user
      end
  
      can :crud, Review do |review|
        user == review.user
      end
  
      can :like, Idea do |idea|
        user.persisted? && user != idea.user  
      end
  
      can :destroy, Like do |like|
        user == like.user
      end
      
    end
  end

  class ApplicationRecord < ActiveRecord::Base
    primary_abstract_class
  end

  class Idea < ApplicationRecord
    has_many :reviews, dependent: :destroy
    
    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes, source: :user

    belongs_to :user

    validates :title, presence: true
    validates :body, presence: true
end

class Like < ApplicationRecord
    belongs_to :user
    belongs_to :idea
  
    validates(
      :idea_id,
      uniqueness: {
          scope: :user_id,
          message: "Has already been liked"
      }
    )
  end

class Review < ApplicationRecord
    belongs_to :idea
    belongs_to :user
end

class User < ApplicationRecord
    has_secure_password :password

    has_many :ideas, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :liked_ideas, through: :likes, source: :idea

    VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX
end

  
