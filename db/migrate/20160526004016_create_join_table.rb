class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table :tienda_products_registries do |t|
      t.index :registry_id
      t.index :product_id
    end
  end
end
