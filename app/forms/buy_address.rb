class BuyAddress
  include ActiveModel::Model
  attr_accessor :post_code, :prefectures_id, :municipal_district, :house_number, :building_name, :phone_number
  attr_accessor :token, :item_id, :user_id

  with_options presence: true do
    # buyテーブルのカラム
    validates :token

    # addressテーブルのカラム
    validates :post_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :prefectures_id, numericality: { other_than: 1, message: "can't be blank" }
    validates :municipal_district
    validates :house_number
    validates :phone_number, format: { with: /\A[0-9]{10,11}\z/, message: 'is invalid. Input half-width characters' }
  end

  def save
    # buyの情報の保存し、buyという変数にいれている
    buy = Buy.create(
      item_id: item_id,
      user_id: user_id,
      token: token
    )
    # addressの情報を保存
    Address.create(
      post_code: post_code,
      prefectures_id: prefectures_id,
      municipal_district: municipal_district,
      house_number: house_number,
      building_name: building_name,
      phone_number: phone_number,
      buy_id: buy.id
    )
  end
end
