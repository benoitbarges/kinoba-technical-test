class AddJtiToTrainers < ActiveRecord::Migration[6.0]
  def change
    add_column :trainers, :jti, :string, null: false
    add_index :trainers, :jti, unique: true
  end
end
