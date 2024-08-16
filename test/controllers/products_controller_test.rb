require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest

  test "Test Index" do
    product = Product.new(
      name: "Chilli",
      price: 1.50,
      sku: 123,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 1,
      category: 2
    )
    product.save

    get(api_v1_products_path)
    assert_response :success
    assert_select 'tbody tr td a', text: 'Chilli'
    assert_select 'tbody tr td', text: '1.5'
    assert_select 'tbody tr td', text: '10.0 gms'
    assert_select 'tbody tr td', text: 'Fruits'
  end

  test "Test show" do
    product = Product.new(
      name: "Chilli",
      price: 1.50,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 2,
      category: 1
    )
    product.save

    get(api_v1_product_path(product.id))
    assert_response :success
    assert_select 'p', text: 'No image available'
    assert_select 'p', text: /Name:\s*Chilli/
    assert_select 'p', text: /Price:\s*1.5/
    assert_select 'p', text: /SKU:\s*#{product.id.to_s}/
    assert_select 'p', text: /Seasonal:\s*Yes/
    assert_select 'p', text: /Quantity:\s*10.0/
    assert_select 'p', text: /Measurement Unit:\s*Kgs/
    assert_select 'p', text: /Category:\s*Vegetables/
  end

  test "Test create" do
    post(api_v1_products_path, params: {
      "authenticity_token"=>"[FILTERED]", "product"=>{"name"=>"Green Chilli", "price"=>"15", "is_seasonal"=>"0", "quantity"=>"34", "measurement_unit"=>"1", "category"=>"2"
    }})
    assert_response :redirect
    assert_redirected_to api_v1_products_url

    assert_equal Product.all.length, 1

    product = Product.all.first

    assert_equal product.name, 'Green Chilli'
    assert_equal product.price, 15
    assert_equal product.is_seasonal, false
    assert_equal product.quantity, 34
    assert_equal product.measurement_unit, 'gms'
    assert_equal product.category, 'Fruits'
  end

  test "Test update" do
    product = Product.new(
      name: "Chilli",
      price: 1.50,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 2,
      category: 1
    )
    product.save

    product = Product.find_by_id(product.id)

    assert_equal product.name, 'Chilli'
    assert_equal product.price, 1.5
    assert_equal product.is_seasonal, true
    assert_equal product.quantity, 10
    assert_equal product.measurement_unit, 'Kgs'
    assert_equal product.category, 'Vegetables'

    put(api_v1_product_path(product.id), params: {
      "authenticity_token"=>"[FILTERED]", "product"=>{"name"=>"Green Chilli", "price"=>"15", "is_seasonal"=>"0", "quantity"=>"34", "measurement_unit"=>"1", "category"=>"2"
    }})
    assert_response :redirect
    assert_redirected_to api_v1_products_url

    product = Product.find_by_id(product.id)

    assert_equal product.name, 'Green Chilli'
    assert_equal product.price, 15
    assert_equal product.is_seasonal, false
    assert_equal product.quantity, 34
    assert_equal product.measurement_unit, 'gms'
    assert_equal product.category, 'Fruits'
  end

  test "Test destroy" do
    product = Product.new(
      name: "Chilli",
      price: 1.50,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 2,
      category: 1
    )
    product.save

    assert_equal Product.all.length, 1

    delete(api_v1_product_path(product.id))
    assert_response :redirect

    assert_equal Product.all.length, 0
  end
end