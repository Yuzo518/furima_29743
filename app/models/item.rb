class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  belongs_to_active_hash :status
  belongs_to_active_hash :area
  belongs_to_active_hash :delivery_fee
  belongs_to_active_hash :date_of_shipment
  belongs_to :user
  has_one_attached :image

  validates :name, :value, :comment, :category, :status, :area, :delivery_fee, :date_of_shipment, presence: true

  validates :category_id, :status_id, :area_id, :delivery_fee_id, :date_of_shipment_id, numericality: { other_than: 1 }
end
