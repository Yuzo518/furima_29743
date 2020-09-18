FactoryBot.define do
  factory :item do
    name                { "ItemaName" }
    value               { 3000 }
    comment             { "ItemeComment" }
    category_id         { 2 }
    status_id           { 2 }
    date_of_shipment_id { 2 }
    area_id             { 2 }
    delivery_fee_id     { 2 }
    association         :user

    after(:build) do |i|
      i.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
