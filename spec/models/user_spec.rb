require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it 'nicknameとemail、passwordとpassword_confimation、
        family_nameとfirst_name、family_name_kanaとfirst_name_kanaとbirthdayが存在すれば登録できること' do
      expect(@user).to be_valid
    end

    it 'nicknameが空では登録できないこと' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname can't be blank")
    end
    it 'emailが空では登録できないこと' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end
    it 'passwordが空では登録できないこと' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
    it 'password存在していてもpassword_confimationが空では登録できないこと' do
      @user.password_confirmation = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
    it 'family_nameが空では登録できないこと' do
      @user.family_name = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Family name can't be blank")
    end
    it 'first_nameが空では登録できないこと' do
      @user.first_name = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("First name can't be blank")
    end
    it 'family_name_kanaが空では登録できないこと' do
      @user.family_name_kana = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Family name kana can't be blank")
    end
    it 'first_name_kanaが空では登録できないこと' do
      @user.first_name_kana = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("First name kana can't be blank")
    end
    it 'birthdayが空では登録できないこと' do
      @user.birthday = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Birthday can't be blank")
    end

    it '重複したemailが存在する場合登録できないこと' do
      @user.save
      another_user = FactoryBot.build(:user)
      another_user.email = @user.email
      another_user.valid?
      expect(another_user.errors.full_messages).to include('Email has already been taken')
    end
    it 'emailは＠を含めた文字列でないと登録できないこと' do
      @user.email = 'yamadaitiro'
      @user.valid?
      expect(@user.errors.full_messages).to include('Email is invalid')
    end
    it 'passwordは６文字以上でないと登録できないこと' do
      test_pass = 'pass1'
      @user.password = test_pass
      @user.password_confirmation = test_pass
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end
    it 'passwordは半角英数混合でないと登録できないこと' do
      test_pass = 'password'
      @user.password = test_pass
      @user.password_confirmation = test_pass
      @user.valid?
      expect(@user.errors.full_messages).to include('Password は英字と数字の両方を含めて設定してください')
    end
    it 'family_nameは全角（漢字・ひらがな・カタカナ）以外だと登録できないこと' do
      test_family_name = 'Yamada'
      @user.family_name = test_family_name
      @user.valid?
      expect(@user.errors.full_messages).to include('Family name は全角文字を使用してください')
    end
    it 'first_nameは全角（漢字・ひらがな・カタカナ）以外だと登録できないこと' do
      test_first_name = 'Ichiro'
      @user.first_name = test_first_name
      @user.valid?
      expect(@user.errors.full_messages).to include('First name は全角文字を使用してください')
    end
    it 'family_name_kanaは全角（カタカナ）以外だと登録できないこと' do
      test_family_name = '山田'
      @user.family_name_kana = test_family_name
      @user.valid?
      expect(@user.errors.full_messages).to include('Family name kana はカタカナを使用してください')
    end
    it 'first_name_kanaは全角（カタカナ）以外だと登録できないこと' do
      test_first_name = '一郎'
      @user.first_name_kana = test_first_name
      @user.valid?
      expect(@user.errors.full_messages).to include('First name kana はカタカナを使用してください')
    end
  end
end
