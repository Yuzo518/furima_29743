class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  belongs_to_active_hash :status
  belongs_to_active_hash :area
  belongs_to_active_hash :delivery_fee
  belongs_to_active_hash :date_of_shipment
  belongs_to :user
  has_one_attached :image

  # 商品名は４０文字以内で必須
  validates :name, presence: true, length: { maximum: 40 }

  # 商品説明は1000文字以内で必須
  validates :comment, presence: true, length: { maximum: 1000 }

  # 商品の価格は半角数字¥300~¥9,999,999の間で必須
  validates :value, presence: true
  validates :value, numericality: { only_integer: true }
  validates :value, numericality: { greater_than_or_equal_to: 300 }
  validates :value, numericality: { less_than_or_equal_to: 9_999_999 }

  # 画像は必須
  validates :image, presence: true

  # カテゴリー、状態、配送料の負担、発送エリア、発送日は必須
  with_options presence: true do
    validates :category
    validates :status_id
    validates :area
    validates :delivery_fee
    validates :date_of_shipment
  end
  # カテゴリー、状態、配送料の負担、発送エリア、発送日は”--”(id:1)以外を選択
  with_options numericality: { other_than: 1 } do
    validates :category_id
    validates :status_id
    validates :area_id
    validates :delivery_fee_id
    validates :date_of_shipment_id
  end
end
