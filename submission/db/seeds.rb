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
