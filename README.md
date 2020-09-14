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
| category           | string     | null: false                    |
| status             | string     | null: false                    |
| area               | string     | null: false                    |
| date_of_shipment   | string     | null: false                    |
| delivery_fee       | string     | null: false                    |
| user_id            | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :buy

## buys テーブル

| Column    | Type       | Options                        |
| --------- | ---------- | ------------------------------ |
| items_id  | references | null: false, foreign_key: true |
| user_id   | references | null: false, foreign_key: true |
| address   | strings    | null: false                    |

### Association

- belongs_to :user
- belongs_to :item