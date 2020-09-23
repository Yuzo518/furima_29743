class Buy < ApplicationRecord
  attr_accessor :token
  belongs_to :user
  belongs_to :item
  has_one :address

  validates :token, presence: true
end

