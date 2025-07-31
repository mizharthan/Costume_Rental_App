class Rental < ApplicationRecord
  belongs_to :costume
  belongs_to :user

  acts_as_taggable_on :wearers
  
  enum status: {
    not_confirmed: 0,
    accepted: 1,
    rejected: 2
  }
  validates :start_date, :end_date, :status, :price, presence: true
end
