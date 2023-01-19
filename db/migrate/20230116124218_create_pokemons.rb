class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :abilities, array: true, default: []
      t.integer :base_experience, default: 0
      t.integer :base_happiness, default: 0
      t.integer :capture_rate, default: 0
      t.string :color
      t.string :description
      t.string :egg_groups, array: true, default: []
      t.integer :gender_rate
      t.string :growth_rate
      t.integer :height, default: 0
      t.string :jap_name
      t.boolean :legendary, default: false
      t.boolean :mythical, default: false
      t.string :name
      t.string :shape
      t.string :species
      t.integer :hp, default: 0
      t.integer :attack, default: 0
      t.integer :defense, default: 0
      t.integer :special_attack, default: 0
      t.integer :special_defense, default: 0
      t.integer :speed, default: 0
      t.string :types, array: true, default: []
      t.integer :weight, default: 0
      t.integer :generation
      t.string :image_url

      t.references :ancestor, foreign_key: { to_table: 'pokemons' }
      t.timestamps null: false
    end
  end
end
