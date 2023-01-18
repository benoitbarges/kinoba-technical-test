class Pokemons::IndexSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :name,
             :types,
             :generation,
             :image_url
end
