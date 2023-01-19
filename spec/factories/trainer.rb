FactoryBot.define do
  factory :trainer, class: Trainer do
    sequence(:email) { |n| "trainer#{n}@pokemon.com" }
    password { SecureRandom.uuid }
  end
end
