class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :items
  has_many :buys

  # ユーザー情報
  # nicknameが必須
  validates :nickname, presence: true

  # emailは＠を含む文字列
  EMAIL_REGEX = /@.+/.freeze
  validates_format_of :email, with: EMAIL_REGEX, message: 'には@を含めた文字列に設定してください'

  # passwordは６文字以上、半角英数混合
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'は英字と数字の両方を含めて設定してください'

  # 本人情報確認

  # family_nameが必須かつ全角（漢字・ひらがな・カタカナ）
  # first_nameが必須かつ全角（漢字・ひらがな・カタカナ）
  FULLWIDTH_REGEX = /\A[ぁ-んァ-ン一-龥]+\z/.freeze
  with_options presence: true, format: { with: FULLWIDTH_REGEX, message: 'は全角文字を使用してください' } do
    validates :family_name
    validates :first_name
  end

  # family_name_kanaが必須かつ全角（カタカナ）
  # first_name_kanaが必須かつ全角（カタカナ）
  KANA_REGEX = /\A[ァ-ン]+\z/.freeze
  with_options presence: true, format: { with: KANA_REGEX, message: 'はカタカナを使用してください' } do
    validates :family_name_kana
    validates :first_name_kana
  end

  # birthdayが必須
  validates :birthday, presence: true
end
