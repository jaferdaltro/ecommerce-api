class Product < ApplicationRecord
  include LikeSearchable
  include Paginatable
  
  belongs_to :productable, polymorphic: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  has_one_attached :image
  validates :image, presence: true

  enum status: { unavailable: 0, available: 1 }
end
