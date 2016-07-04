module Tienda
  class RegistriesController < Tienda::ApplicationController

    #layout 'tienda/sub'
    skip_before_filter :login_required, only: [:new, :create, :reset]

    before_filter { @active_nav = :registry }

    def index
      @registries = Tienda::Registry.all
    end

    def new
      @registry = Tienda::Registry.new
      @products = Tienda::Product.all
    end

    def create
      @registry = Tienda::Registry.new(safe_params)
      if @registry.save
        redirect_to :registries, flash: { notice: t('tienda.registry.create_notice') }
      else
        render :new
      end
    end

    def update
      @registry = Tienda::Registry.find_by_id(params[:id])
      if @registry.update(safe_params)
        redirect_to registry_path(@registry.id), flash: { notice: t('tienda.registry.update_notice') }
      else
        render action: "edit"
      end
    end

    def show
      @registry = Tienda::Registry.validate_and_find(params[:id])
    end

    def edit
      @registry = Tienda::Registry.validate_and_find(params[:id])
    end

    def destroy
      @registry = Tienda::Registry.find(params[:id])
      @registry.destroy
      redirect_to :registries, flash: {notice: t('tienda.registries.delete_message')}
    end

    private

    def safe_params
      params[:registry].permit(:name, :products, :slug, :category, :active, :product_ids => [])
    end

  end
end
