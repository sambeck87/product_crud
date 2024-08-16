class Product < ApplicationRecord

  has_one_attached :image

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :measurement_unit, presence: true
  validates :category, presence: true

  # category
  enum category: {
    Vegetables: 1,
    Fruits: 2,
    Meat: 3,
    Dairy: 4,
    Grains: 5,
    Bakery: 6,
    Snacks: 7,
    Other: 8
  }

  # measurement_unit
  enum measurement_unit: {
    gms: 1,
    Kgs: 2,
    Piece: 3,
    Lt: 4,
    Lb: 5,
    Oz: 6,
    Undefined: 7
  }

  after_create :set_sku

  private

  def set_sku
    update_column(:sku, id) if sku.nil?
  end
end