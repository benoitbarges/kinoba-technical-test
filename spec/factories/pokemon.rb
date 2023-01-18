FactoryBot.define do
  factory :pokemon, class: Pokemon do
    sequence(:name) { |n| "Pokemon ##{n}" }
  end
end
