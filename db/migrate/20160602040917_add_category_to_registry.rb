class AddCategoryToRegistry < ActiveRecord::Migration
  def change
    add_column :tienda_registries, :category, :string
  end
end
