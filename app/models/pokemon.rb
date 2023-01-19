class Pokemon < ApplicationRecord
  belongs_to :ancestor, foreign_key: :ancestor_id, class_name: 'Pokemon', optional: true
  has_many :catched_pokemons
  has_many :trainers, through: :catched_pokemons
  has_many :evolutions, ->(pokemon) { where ancestor_id: pokemon.id }, class_name: 'Pokemon', foreign_key: :ancestor_id, dependent: :destroy

  paginates_per 10
end
