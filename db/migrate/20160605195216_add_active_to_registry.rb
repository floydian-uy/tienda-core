class AddActiveToRegistry < ActiveRecord::Migration
  def change
    add_column :tienda_registries, :active, :boolean, :default => false
  end
end
