class Costume < ApplicationRecord
  belongs_to :user
  has_many :rentals, dependent: :destroy
  has_many_attached :photos

  validates :name, :size, :description, :price_per_day, presence: true
end
