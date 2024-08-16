class Api::V1::ProductsController < ApplicationController
  include Params

  def new
    @product = Product.new
  end

  def edit
    product_id = params_extract_integer!(@product, params, :id)
    @product = Product.find_by(id: product_id)
  end

  # GET api/v1/products
  def index
    @products = Product.all
  end

  # GET api/v1/products/:id
  def show
    product_id = params_extract_integer!(@product, params, :id)
    @product = Product.find_by(id: product_id)
    return not_found unless @product
  end

  # POST api/v1/products
  def create
    @product = Product.new(attach_image)
    build_params(@product)

    if @product.errors.any?
      flash.now[:alert] = @product.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    elsif build_params(@product)
      @product.save
      respond_to do |format|
        format.html { redirect_to api_v1_products_url, notice: 'Product was successfully created.' }
      end
    else
      respond_to do |format|
        format.html{
          flash.now[:alert] = 'There was an error creating the product.'
          render :new, status: :unprocessable_entity
        }
      end
    end
  end

  # PUT /api/v1/products/:id
  def update
    product_id = params_extract_integer!(@product, params, :id)
    @product = Product.find_by(id: product_id)
    return not_found unless @product
    @product.update(attach_image)
    @product.with_lock do
			return unless build_params(@product)

      if @product.errors.any?
        flash.now[:alert] = @product.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      elsif @product.save
        respond_to do |format|
          format.html { redirect_to api_v1_products_url, notice: 'Product was successfully updated.' }
          format.json { render :show, status: :ok, location: @product }
        end
      else
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
		end
  end

  # GET /api/v1/products/:id
  def destroy
    product_id = params_extract_integer!(@product, params, :id)
    @product = Product.find_by(id: product_id)
    return not_found unless @product

    @product.with_lock do
			@product.destroy
		end

    respond_to do |format|
      format.html { redirect_to api_v1_products_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def safe_params
    @safe_params ||= params_extract_resource!(@product, params, :product, permit: [
      :name,
			:price,
			:is_seasonal,
      :image,
      :quantity,
      :measurement_unit,
      :category
		])
  end

  def build_params(product)
    product_params = safe_params

    required = product.new_record?

    product.name = params_extract_string!(product, product_params, :name, required: true) if
      product_params.has_key?(:name) or required

    product.price = params_extract_decimal!(product, product_params, :price, required: true) if
      product_params.has_key?(:price) or required

    product.is_seasonal = params_extract_boolean!(product, product_params, :is_seasonal) if
      product_params.has_key?(:is_seasonal)

    product.quantity = params_extract_decimal!(product, product_params, :quantity, required: true) if
      product_params.has_key?(:quantity) or required

    product.measurement_unit = params_extract_integer!(product,
      product_params, :measurement_unit, range: 1..7, required: true) if
      product_params.has_key?(:measurement_unit) or required

    product.category = params_extract_integer!(product, product_params, :category, range: 1..8, required: true) if
      product_params.has_key?(:category) or required

    product
  end

  def attach_image
    params.require(:product).permit(:image)
  end
end