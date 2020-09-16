FactoryBot.define do
  factory :user do
    nickname              {"ニックネーム"}
    email                 {Faker::Internet.free_email}
    password = Faker::Internet.password(min_length: 6)
    password              {password}
    password_confirmation {password}
    family_name           {"山田"}
    first_name            {"一郎"}
    family_name_kana      {"ヤマダ"}
    first_name_kana       {"イチロウ"}
    birthday              {19890518}
  end
end