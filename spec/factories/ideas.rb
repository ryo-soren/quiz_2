FactoryBot.define do
  factory :idea do
    title { Faker::Hacker.noun }
    body { Faker::Hacker.noun }
    association :user, factory: :user

  end
end

