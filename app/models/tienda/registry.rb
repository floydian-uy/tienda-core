module Tienda
  class Registry < ActiveRecord::Base
    before_create :generate_token

    has_and_belongs_to_many :products, :foreign_key => :registry_id, :class_name => 'Tienda::Product'

    validates :name, presence: true
    validates :slug, presence: true
    validates :slug, format: { with: /\A[a-zA-Z0-9-]+\z/,
                                      message: "only allows letters and hyphens." }

    def self.validate_and_find(id_or_slug)
      registry = nil
      if(id_or_slug=~/^[0-9]+$/)
        puts "Gets here 1"
        registry = Tienda::Registry.find(id_or_slug)
      elsif(id_or_slug=~/[0-9A-Za-z-_]/)
        registry = Tienda::Registry.find_by_slug(id_or_slug)
        puts "Gets here 2"
      end
      puts "Registry: #{registry}"
      registry
    end

    def generate_token
      self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
    end
  end
end
