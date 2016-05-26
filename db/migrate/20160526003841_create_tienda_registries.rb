class CreateTiendaRegistries < ActiveRecord::Migration
  def change
    create_table :tienda_registries do |t|
      t.string :name
      t.string :token

      t.timestamps null: false
    end
  end
end
