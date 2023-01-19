def fetch_pokemons(url)
  response = HTTParty.get(url)
  response['results'].each do |result|
    pokemon = HTTParty.get(result['url'])
    species = HTTParty.get(pokemon['species']['url'])

    generation = species['generation']['url'].split('/').last.to_i
    # There are missing data on 9th generation for the moment, so we skip it.
    next if generation == 9

    pokemon = Pokemon.new({
      id: pokemon['id'],
      abilities: pokemon['abilities'].map { |e| e['ability']['name'] },
      base_experience: pokemon['base_experience'],
      base_happiness: species['base_happiness'],
      capture_rate: species['capture_rate'],
      color: species.dig('color', 'name') || 'no color',
      description: species['flavor_text_entries']&.find { |e| e['language']['name'] == 'en' }&.dig('flavor_text') || 'unknown',
      egg_groups: species['egg_groups'].map { |e| e['name'] },
      gender_rate: species['gender_rate'],
      growth_rate: species.dig('growth_rate', 'name') || 'unknown',
      height: pokemon['height'],
      jap_name: species['names'].find { |e| e['language']['name'] == 'ja' }&.dig('name') || 'ポケットモン',
      legendary: species['is_legendary'],
      mythical: species['is_mythical'],
      name: pokemon['name'],
      shape: species.dig('shape', 'name') || 'unknown',
      species: pokemon['species']['name'],
      hp: pokemon['stats'].find { |e| e['stat']['name'] == 'hp' }['base_stat'],
      attack: pokemon['stats'].find { |e| e['stat']['name'] == 'attack' }['base_stat'],
      defense: pokemon['stats'].find { |e| e['stat']['name'] == 'defense' }['base_stat'],
      special_attack: pokemon['stats'].find { |e| e['stat']['name'] == 'special-attack' }['base_stat'],
      special_defense: pokemon['stats'].find { |e| e['stat']['name'] == 'special-defense' }['base_stat'],
      speed: pokemon['stats'].find { |e| e['stat']['name'] == 'hp' }['base_stat'],
      types: pokemon['types'].map { |e| e['type']['name'] },
      weight: pokemon['weight'],
      ancestor_id: species['evolves_from_species']&.dig('url')&.split('/')&.last&.to_i,
      generation: generation,
      image_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/#{pokemon['id']}.png"
    })

    if pokemon.save
      puts "##{pokemon.id} #{pokemon.name} seeded!"
    else
      puts "##{pokemon.id} #{pokemon.name} not seeded ❌"
    end

    if result == response['results'].last && response['next'].present?
      fetch_pokemons(response['next'])
    end
  end
end

ActiveRecord::Base.connection.disable_referential_integrity do
  Pokemon.destroy_all
  puts 'Done ✅'

  puts 'Creating all pokemons...'
  fetch_pokemons('https://pokeapi.co/api/v2/pokemon')
  puts 'Done ✅'
end
