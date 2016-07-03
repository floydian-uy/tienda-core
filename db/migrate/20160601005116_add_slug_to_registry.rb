class AddSlugToRegistry < ActiveRecord::Migration
  def change
    add_column :tienda_registries, :slug, :string, index: true
  end
end
