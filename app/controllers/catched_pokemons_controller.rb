class CatchedPokemonsController < ApplicationController
  before_action :authenticate_trainer!

  def create
    catched_pokemon = CatchedPokemon.new(trainer: current_trainer, pokemon_id: catched_pokemon_params[:pokemon_id])

    if catched_pokemon.save
      render json: Pokemons::ShowSerializer.new(
        catched_pokemon.pokemon,
        { params: { current_trainer: current_trainer } }
      ).serializable_hash
    else
      render json: {
        status: {
          code: 422,
          errors: catched_pokemon.errors.full_messages,
          message: 'CatchedPokemon could not be created successfully'
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    catched_pokemon = CatchedPokemon.find(params[:id])

    if catched_pokemon.destroy
      render json: Pokemons::ShowSerializer.new(
        catched_pokemon.pokemon,
        { params: { current_trainer: current_trainer } }
      ).serializable_hash
    else
      render json: {
        status: {
          code: 422,
          errors: catched_pokemon.errors.full_messages,
          message: 'CatchedPokemon could not be destroyed successfully'
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def catched_pokemon_params
    params.require(:catched_pokemon).permit(:pokemon_id)
  end
end
