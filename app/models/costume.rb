class Costume < ApplicationRecord
  belongs_to :user
  has_many :rentals, dependent: :destroy
  has_many_attached :photos
  has_one_attached :photo

  validates :name, :size, :description, :price_per_day, presence: true
end
