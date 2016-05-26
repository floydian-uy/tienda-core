class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table :tienda_products_registries do |t|
      t.string :registry_id, index: true
      t.string :product_id, inde: true
    end
  end
end
