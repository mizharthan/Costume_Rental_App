class Rental < ApplicationRecord
  belongs_to :costume
  belongs_to :user

  validates :status, inclusion: %w(not_confirmed confirmed)
  validates :start_date, :end_date, :status, :price, presence: true
end
