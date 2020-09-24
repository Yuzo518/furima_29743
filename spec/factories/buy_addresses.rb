FactoryBot.define do
  factory :buy_address do
    # buyテーブル
    token               { 'tok_dbd375d61aa67d4a61fb4755dae5' }
    user_id             { :user }
    item_id             { :item }

    # addressテーブル
    post_code           { '123-4567' }
    prefectures_id      { 2 }
    municipal_district  { '相模原市緑区' }
    house_number        { '２丁目１３番１５号' }
    building_name       { 'シティハイツ10A号' }
    phone_number        { '09012345678' }
  end
end
