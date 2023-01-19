class Pokemons::ShowSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :abilities,
             :base_experience,
             :base_happiness,
             :capture_rate,
             :color,
             :description,
             :egg_groups,
             :gender_rate,
             :growth_rate,
             :height,
             :jap_name,
             :legendary,
             :mythical,
             :name,
             :shape,
             :species,
             :hp,
             :attack,
             :defense,
             :special_attack,
             :special_defense,
             :speed,
             :types,
             :generation,
             :image_url

  attribute :catched_pokemon do |pokemon, params|
    pokemon.catched_pokemons.find_by(trainer: params[:current_trainer])
  end

  attribute :evolutions do |pokemon|
    pokemon.evolutions
  end

  attributes :stats do |pokemon|
    [
      { name: 'hp', value: pokemon.hp },
      { name: 'attack', value: pokemon.attack },
      { name: 'defense', value: pokemon.defense },
      { name: 'special attack', value: pokemon.special_attack },
      { name: 'special defense', value: pokemon.special_defense },
      { name: 'speed', value: pokemon.speed }
    ]
  end
end
