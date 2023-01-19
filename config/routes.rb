Rails.application.routes.draw do
  devise_for :trainers, controllers: {
    sessions: 'trainers/sessions',
    registrations: 'trainers/registrations'
  }

  resources :pokemons, only: [:index, :show] do
    collection do
      get :filter
      get '/pokedex/:trainer_id', to: 'pokemons#pokedex'
    end
  end

  resources :catched_pokemons, only: [:create, :destroy]
end
