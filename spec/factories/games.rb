FactoryBot.define do
  factory :game do
    mode { %i(pvp pve both).sample }
    release_at { Faker::Date.between(from: '2014-09-23', to: '2014-09-25') }
    developer { Faker::DcComics.hero }
    system_requirement
  end
end
