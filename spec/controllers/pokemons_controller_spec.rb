require 'rails_helper'

RSpec.describe PokemonsController, type: :controller do
  describe '#index' do
    subject { get :index, params: params }

    let(:trainer) { create(:trainer) }
    let!(:pokemon_1) { create(:pokemon, generation: 1) }
    let!(:pokemon_2) { create(:pokemon, generation: 1) }
    let!(:pokemon_3) { create(:pokemon, generation: 2) }
    let(:page) { 1 }

    let(:params) { { generation: 1, page: page } }

    before { sign_in(trainer) }

    it 'should create a catched pokemon associated to current trainer' do
      subject
      body = JSON.parse(response.body)
      expect(body['pokemons']).to eq(Pokemons::IndexSerializer.new(Pokemon.where(generation: 1)).as_json)
      expect(body['generations']).to contain_exactly(1, 2)
      expect(body['has_more']).to eq(false)
    end

    context 'when there are more than pagination can handle at once' do
      before { Pokemon.paginates_per(1) }
      after { Pokemon.paginates_per(25) }

      context 'on first page with more pokemons' do
        it 'correctly paginates pokemons' do
          subject
          body = JSON.parse(response.body)
          expect(body['pokemons']).to eq(Pokemons::IndexSerializer.new(Pokemon.where(id: pokemon_1.id)).as_json)
          expect(body['has_more']).to eq(true)
        end
      end

      context 'on last page' do
        let(:page) { 2 }

        it 'correctly paginates pokemons' do
          subject
          body = JSON.parse(response.body)
          expect(body['pokemons']).to eq(Pokemons::IndexSerializer.new(Pokemon.where(id: pokemon_2.id)).as_json)
          expect(body['has_more']).to eq(false)
        end
      end
    end
  end

  describe '#show' do
    subject { get :show, params: params }

    let(:trainer) { create(:trainer) }
    let(:pokemon) { create(:pokemon) }

    let(:params) { { id: pokemon.id } }

    before { sign_in(trainer) }

    it 'should return a pokemon' do
      subject
      body = JSON.parse(response.body)
      expect(body).to eq(Pokemons::ShowSerializer.new(pokemon, { params: { current_trainer: trainer } }).as_json)
    end
  end

  describe '#filter' do
    subject { get :filter, params: params }

    let(:trainer) { create(:trainer) }
    let(:pokemon) { create(:pokemon, generation: 1) }

    let(:params) { { filter: filter, generation: pokemon.generation } }

    before { sign_in(trainer) }

    context 'whithout catched pokemon' do
      context 'and catched filter' do
        let(:filter) { 'catched' }

        it 'should not return pokemons' do
          subject
          body = JSON.parse(response.body)
          expect(body['filtered_pokemons']['data']).to be_empty
        end
      end

      context 'and notCatched filter' do
        let(:filter) { 'notCatched' }

        it 'should return pokemons' do
          subject
          body = JSON.parse(response.body)
          expect(body['filtered_pokemons']).to eq(Pokemons::IndexSerializer.new(Pokemon.all).as_json)
        end
      end
    end

    context 'whit catched pokemon' do
      let!(:catched_pokemon) { create(:catched_pokemon, pokemon: pokemon, trainer: trainer) }

      context 'and catched filter' do
        let(:filter) { 'catched' }

        it 'should return pokemons' do
          subject
          body = JSON.parse(response.body)
          expect(body['filtered_pokemons']).to eq(Pokemons::IndexSerializer.new(Pokemon.all).as_json)
        end
      end

      context 'and notCatched filter' do
        let(:filter) { 'notCatched' }

        it 'should not return pokemons' do
          subject
          body = JSON.parse(response.body)
          expect(body['filtered_pokemons']['data']).to be_empty
        end
      end

      context 'and catchedAtASC filter' do
        let(:filter) { 'catchedAtASC' }
        let(:pokemon_2) { create(:pokemon, generation: 1) }
        let!(:catched_pokemon_2) { create(:catched_pokemon, pokemon: pokemon_2, trainer: trainer) }

        it 'should return pokemons' do
          subject
          body = JSON.parse(response.body)
          ids = body['filtered_pokemons']['data'].map { |p| p['attributes']['id'] }
          expect(ids).to eq([pokemon.id, pokemon_2.id])
        end
      end

      context 'and catchedAtDESC filter' do
        let(:filter) { 'catchedAtDESC' }
        let(:pokemon_2) { create(:pokemon, generation: 1) }
        let!(:catched_pokemon_2) { create(:catched_pokemon, pokemon: pokemon_2, trainer: trainer) }

        it 'should return pokemons' do
          subject
          body = JSON.parse(response.body)
          ids = body['filtered_pokemons']['data'].map { |p| p['attributes']['id'] }
          expect(ids).to eq([pokemon_2.id, pokemon.id])
        end
      end
    end
  end
end
