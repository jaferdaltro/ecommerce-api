require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:name)}
  it { is_expected.to validate_presence_of(:profile)}
  it { is_expected.to define_enum_for(:profile).with_values({ admin: 0, client: 1})}

  xit "is invalid if a duplicated email" do
    User.create(name: "example", profile: 0, email: "example@email.com")
    user = User.new(name: "example2", profile: 0, email: "example@email.com", password: "123456")
    user.valid?
    expect(user.errors.messages[:email]).to include "has already be taken"
  end

  it_behaves_like "name searchable concern", :user
  it_behaves_like "paginatable concern", :user
end
