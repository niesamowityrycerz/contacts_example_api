class Address < ApplicationRecord

  belongs_to :contact

  validates :city, presence: true
  #validates :contact_id, presence: true
  validates_numericality_of :street_number, greater_than: 0, only_integer: true


end
