# README

# テーブル設計

## users テーブル

| Column           | Type    | Options     |
| ---------------- | ------- | ----------- |
| nickname         | string  | null: false |
| email            | string  | null: false |
| password         | string  | null: false |
| family_name      | string  | null: false |
| first_name       | string  | null: false |
| family_name_kana | string  | null: false |
| first_name_kana  | string  | null: false |
| birthday         | integer | null: false |

### Association

- has_many :items
- has_many :buys

## items テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| name               | string     | null: false                    |
| value              | integer    | null: false                    |
| comment            | string     | null: false                    |
| category           | integer    | null: false                    |
| status             | integer    | null: false                    |
| area               | integer    | null: false                    |
| date_of_shipment   | integer    | null: false                    |
| delivery_fee       | integer    | null: false                    |
| user               | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :buy

## buys テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| item   | references | null: false, foreign_key: true |
| user   | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_one: address

## address テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| post_code          | integer    | null: false                    |
| prefectures        | integer    | null: false                    |
| municipal_district | string     | null: false                    |
| house_number       | string     | null: false                    |
| building_name      | string     |                                |
| phone_number       | integer    | null: false                    |
| buy                | references | null: false, foreign_key: true |

### Association

- belongs_to :buy