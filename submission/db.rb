class CreateIdeas < ActiveRecord::Migration[7.0]
    def change
      create_table :ideas do |t|
        t.string :title
        t.text :body
        t.timestamps
      end
    end
  end
  
  class CreateUsers < ActiveRecord::Migration[7.0]
    def change
      create_table :users do |t|
        t.string :first_name
        t.string :last_name
        t.string :email, index: {unique: true}
        t.string :password_digest
        t.timestamps
      end
    end
  end

  class CreateReviews < ActiveRecord::Migration[7.0]
    def change
      create_table :reviews do |t|
        t.text :body
        t.references :idea, null: false, foreign_key: true
  
        t.timestamps
      end
    end
  end

  class AddUserReferencesToReviews < ActiveRecord::Migration[7.0]
    def change
      add_reference :reviews, :user, null: false, foreign_key: true
    end
  end
  
  class AddUserReferencesToIdeas < ActiveRecord::Migration[7.0]
    def change
      add_reference :ideas, :user, null: false, foreign_key: true
    end
  end

  class CreateLikes < ActiveRecord::Migration[7.0]
    def change
      create_table :likes do |t|
        t.references :user, null: false, foreign_key: true
        t.references :idea, null: false, foreign_key: true
  
        t.timestamps
      end
    end
  end
  
  # This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_15_003820) do
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
  
    create_table "ideas", force: :cascade do |t|
      t.string "title"
      t.text "body"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "user_id", null: false
      t.index ["user_id"], name: "index_ideas_on_user_id"
    end
  
    create_table "likes", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "idea_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["idea_id"], name: "index_likes_on_idea_id"
      t.index ["user_id"], name: "index_likes_on_user_id"
    end
  
    create_table "reviews", force: :cascade do |t|
      t.text "body"
      t.bigint "idea_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "user_id", null: false
      t.index ["idea_id"], name: "index_reviews_on_idea_id"
      t.index ["user_id"], name: "index_reviews_on_user_id"
    end
  
    create_table "users", force: :cascade do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "email"
      t.string "password_digest"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["email"], name: "index_users_on_email", unique: true
    end
  
    add_foreign_key "ideas", "users"
    add_foreign_key "likes", "ideas"
    add_foreign_key "likes", "users"
    add_foreign_key "reviews", "ideas"
    add_foreign_key "reviews", "users"
  end

Idea.destroy_all
Review.destroy_all
Like.destroy_all
User.destroy_all

10.times do
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name}@#{last_name}.com",
    password: "abc"
    )
end
users = User.all

50.times do
    created_at = Faker::Date.backward(days: 365*3)
    i = Idea.create(
        title: Faker::Hacker.say_something_smart,
        body: Faker::Lorem.sentence(random_words_to_add: 10),
        created_at: created_at,
        updated_at: created_at,
        user: users.sample
    )
    if i.valid?
        rand(1..10).times do
            Review.create(
                body: Faker::Lorem.sentence(random_words_to_add: 10), 
                idea: i, 
                user: users.sample
            )
        end
        i.likers = users.shuffle.slice(0, rand(users.count))
    end
end

ideas = Idea.all
reviews = Review.all
likes = Like.all

puts "Users = #{users.count}"
puts "ideas = #{ideas.count}"
puts "reviews = #{reviews.count}"
puts "likes = #{likes.count}"
