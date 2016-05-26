class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :tienda_registries, :tienda_products do |t|
      t.index [:registry_id, :product_id]
      t.index [:product_id, :registry_id]
    end
  end
end
