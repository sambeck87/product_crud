require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "Model test" do
    product = Product.new(
      price: 1.50,
      sku: 123,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 1,
      category: 2
    )
    assert_not product.save, "Saved the product without a name"

    product = Product.new(
      name: "Chilli",
      sku: 123,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 1,
      category: 2
    )
    assert_not product.save, "Saved the product without a price"

    product = Product.new(
      name: "Chilli",
      price: 1.50,
      sku: 123,
      is_seasonal: true,
      measurement_unit: 1,
      category: 2
    )
    assert_not product.save, "Saved the product without a quantity"

    product = Product.new(
      name: "Chilli",
      price: 1.50,
      sku: 123,
      is_seasonal: true,
      quantity: 10,
      category: 2
    )
    assert_not product.save, "Saved the product without a measurement_unit"

    product = Product.new(
      name: "Chilli",
      price: 1.50,
      sku: 123,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 1
    )
    assert_not product.save, "Saved the product without a category"

    product = Product.new(
      name: "Chilli",
      price: 1.50,
      sku: 123,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 1,
      category: 2
    )
    assert product.save, "Saved the product with diplicated name"

    product = Product.new(
      name: "Chilli",
      price: 1.50,
      sku: 123,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 1,
      category: 2
    )
    assert_not product.save, "Saved the product with diplicated name"

    product = Product.new(
      name: "Carrot",
      price: 0,
      sku: 342,
      is_seasonal: true,
      quantity: 10,
      measurement_unit: 1,
      category: 2
    )
    assert_not product.save, "Price should be greater than 0"
  end
end
