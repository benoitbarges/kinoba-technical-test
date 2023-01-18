FactoryBot.define do
  factory :catched_pokemon, class: CatchedPokemon do
    association :trainer, factory: :trainer
    association :pokemon, factory: :pokemon
  end
end
