require 'roo'

module Tienda
  class Product < ActiveRecord::Base

    # Add dependencies for products
    require_dependency 'tienda/product/product_attributes'
    require_dependency 'tienda/product/variants'

    # To preserve backwards compatibility
    alias_attribute :stock, :stock_count
    alias_attribute :images, :product_images

    # The product's category
    #
    # @return [Tienda::ProductCategory]
    belongs_to :product_category

    # The product's tax rate
    #
    # @return [Tienda::TaxRate]
    belongs_to :tax_rate

    # Ordered items which are associated with this product
    has_many :order_items, dependent: :restrict_with_exception, as: :ordered_item

    # Orders which have ordered this product
    has_many :orders, through: :order_items

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, dependent: :destroy

    # Product Images
    has_many :product_images, dependent: :destroy
    accepts_nested_attributes_for :product_images, reject_if: proc { |attributes| attributes['image'].blank? }, allow_destroy: true

    # Validations
    with_options if: Proc.new { |p| p.parent.nil? } do |product|
      product.validates :product_category_id, presence: true
      product.validates :description, presence: true
      product.validates :short_description, presence: true
    end
    validates :name, presence: true
    validates :permalink, presence: true, uniqueness: true, permalink: true
    validates :sku, presence: true
    validates :weight, numericality: true
    validates :price, numericality: true
    validates :cost_price, numericality: true, allow_blank: true

    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }

    # All active products
    scope :active, -> { where(active: true) }

    # All inactive products
    scope :inactive, -> { where(active: false) }

    # All in stock products
    scope :in_stock, -> { where('stock_count > 0') }

    # All not in stock products
    scope :no_stock, -> { where(stock_count: 0) }

    # All featured products
    scope :featured, -> { where(featured: true) }

    # All products ordered with default items first followed by name ascending
    scope :ordered, -> { order(default: :desc, name: :asc) }

    # Return the name of the product
    #
    # @return [String]
    def full_name
      self.parent ? "#{self.parent.name} (#{name})" : name
    end

    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless self.active?
      return false if self.has_variants?
      true
    end

    # The price for the product
    #
    # @return [BigDecimal]
    def price
      self.default_variant ? self.default_variant.price : read_attribute(:price)
    end

    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      self.default_variant ? self.default_variant.in_stock? : (stock_control? ? stock_count > 0 : true)
    end

    # Return all product categories
    #
    # @return [Array]
    def categories
      parent_category_id = product_category.id
      cats = []
      while parent_category_id != nil
        c = Tienda::ProductCategory.find(parent_category_id)
        cats << c
        parent_category_id = c.parent_id
      end
      cats
    end

    # Search for products which include the given attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Tienda::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    #
    # @return [Enumerable]
    def self.with_attributes(key, values)
      product_ids = Tienda::ProductAttribute.searchable.where(key: key, value: values).pluck(:product_id).uniq
      where(id: product_ids)
    end

    # Imports products from a spreadsheet file
    # Example:
    #
    #   Tienda:Product.import("path/to/file.csv")
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        # Don't import products where the name is blank
        unless row["name"].nil?
          if product = find_by(name: row["name"])
            # Dont import products with the same name but update quantities if they're not the same
            qty = row["qty"].to_i
            product.stock_level_adjustments.create!(description: I18n.t('tienda.import'), adjustment: qty) if qty > 0 && qty != product.stock
          else
            product = new(row)
            product.product_category_id =
              Tienda::ProductCategory.find_or_create_by(name: row['category_name']).id
            product.save!

            # Create quantities
            qty = row["qty"].to_i
            product.stock_level_adjustments.create!(description: I18n.t('tienda.import'), adjustment: qty) if qty > 0
          end
        end
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise I18n.t('tienda.imports.errors.unknown_format', filename: File.original_filename)
      end
    end

  end
end
