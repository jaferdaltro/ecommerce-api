FactoryBot.define do
  factory :product do
    sequence(:name) {|n| "product #{n}" }
    description { Faker::Loren.paragraph }
    price { Faker::Commerce.price(range: 100.0..400.0) }
  end
end
