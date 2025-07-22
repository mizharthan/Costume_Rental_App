class Costume < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :name, :size, :desccription, :price_per_day, presence: true
end
