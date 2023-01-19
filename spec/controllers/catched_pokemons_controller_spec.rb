require 'rails_helper'

RSpec.describe CatchedPokemonsController, type: :controller do
  describe '#create' do
    subject { post :create, params: params }

    let(:trainer) { create(:trainer) }
    let(:pokemon) { create(:pokemon) }

    let(:params) do
      { catched_pokemon: { pokemon_id: pokemon.id } }
    end

    before { sign_in(trainer) }

    it 'should create a catched pokemon associated to current trainer' do
      expect { subject }.to change { CatchedPokemon.count }.from(0).to(1)
      body = JSON.parse(response.body)
      expect(body).to eq(Pokemons::ShowSerializer.new(pokemon, { params: { current_trainer: trainer } }).as_json)
    end

    context 'when missing pokemon_id params' do
      let(:params) do
        { catched_pokemon: { pokemon_id: nil } }
      end

      it 'should return a 422' do
        expect { subject }.not_to change { Pokemon.count }
        body = JSON.parse(response.body)
        expect(body['status']['code']).to eq(422)
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: params }

    let(:trainer) { create(:trainer) }
    let!(:catched_pokemon) { create(:catched_pokemon) }

    let(:params) { { id: catched_pokemon.id } }

    before { sign_in(trainer) }

    it 'should desrtoy a catched pokemon' do
      expect { subject }.to change { CatchedPokemon.count }.from(1).to(0)
      body = JSON.parse(response.body)
      expect(body).to eq(Pokemons::ShowSerializer.new(catched_pokemon.pokemon, { params: { current_trainer: trainer } }).as_json)
    end

    context 'when destroy does not work' do
      let(:params) { { id: catched_pokemon.id } }

      before do
        allow(CatchedPokemon).to receive(:find).and_return(catched_pokemon)
        allow(catched_pokemon).to receive(:destroy).and_return(false)
      end

      it 'should return a 422' do
        expect { subject }.not_to change { CatchedPokemon.count }
        body = JSON.parse(response.body)
        expect(body['status']['code']).to eq(422)
      end
    end
  end
end
