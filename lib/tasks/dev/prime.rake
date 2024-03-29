if Rails.env.development? || Rails.env.test?
  require 'factory_bot'

  namespace :dev do
    desc 'Create development data'
    task prime: 'db:setup' do
      include FactoryBot::Syntax::Methods

      15.times do
        profile = [:admin, :client].sample

        create(:user, profile: profile)
      end

      system_requirements = []
      ['Basic', 'Intermediate', 'Advanced'].each do |sr_name|
        system_requirements << create(:system_requirement, name: sr_name)
      end

      15.times do
        coupon_status = [:active, :inactive].sample
        create(:coupon, status: coupon_status)
      end

      categories = []
      25.times do
        categories << create(:category, name: Faker::Game.unique.genre)
      end

      30.times do
        game_name = Faker::Game.unique.title
        availability = [:available, :unavailable].sample
        categories_count = rand(0..3)
        featured = [true, false].sample
        price = Faker::Commerce.price(range: 5.0..30.0)
        release_at =  (0..15).to_a.sample.days.ago
        game_categories_ids = []
        categories_count.times { game_categories_ids << Category.all.sample.id }
        game = create(:game, system_requirement: system_requirements.sample, release_at: release_at)
        create(:product, name: game_name, status: availability, featured: featured, price: price,
                         category_ids: game_categories_ids, productable: game)
      end
    end
  end
end
