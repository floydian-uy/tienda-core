module Tienda
  class Registry < ActiveRecord::Base
    has_and_belongs_to_many :tienda_products, :class_name => 'Tienda::Product', as: :products
  end
end
