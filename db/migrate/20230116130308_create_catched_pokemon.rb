class CreateCatchedPokemon < ActiveRecord::Migration[6.0]
  def change
    create_table :catched_pokemons do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
