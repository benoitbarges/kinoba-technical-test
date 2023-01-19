class PokemonsController < ApplicationController
  respond_to :json
  before_action :authenticate_trainer!, only: [:index, :filter]

  def index
    pokemons = Pokemon.where(generation: params[:generation])
    paginated_pokemons = pokemons.page(params[:page])

    render json: {
      pokemons: Pokemons::IndexSerializer.new(paginated_pokemons).serializable_hash,
      generations: Pokemon.pluck(:generation).uniq,
      has_more: paginated_pokemons.next_page.present?
    }
  end

  def show
    pokemon = Pokemon.find(params[:id])
    render json: Pokemons::ShowSerializer.new(
      pokemon,
      { params: { current_trainer: current_trainer } }
    ).serializable_hash
  end

  def filter
    pokemon_ids = current_trainer.catched_pokemons.pluck(:pokemon_id)
    pokemons = Pokemon.where(generation: params[:generation])
    pokemons = case params[:filter]
    when 'catched'
      pokemons.where(id: pokemon_ids)
    when 'notCatched'
      pokemons.where.not(id: pokemon_ids)
    when 'catchedAtASC'
      pokemons.where(id: pokemon_ids).to_a.sort! { |a, b| a.id <=> b.id }
    when 'catchedAtDESC'
      pokemons.where(id: pokemon_ids).to_a.sort! { |a, b| b.id <=> a.id }
    else
      pokemons
    end
    paginated_pokemons = Kaminari.paginate_array(pokemons).page(params[:page]).per(10)

    render json: {
      filtered_pokemons: Pokemons::IndexSerializer.new(paginated_pokemons).serializable_hash,
      has_more: paginated_pokemons.next_page.present?
    }
  end

  def pokedex
    pokemons = Pokemon.joins(:catched_pokemons).where(catched_pokemons: { trainer_id: params[:trainer_id] })

    render json: Pokemons::IndexSerializer.new(pokemons).serializable_hash
  end
end
