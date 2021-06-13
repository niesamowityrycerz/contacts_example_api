# frozen_string_literal: true

class Contact < ApplicationRecord

  has_many :addresses

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :addresses
end
