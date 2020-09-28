require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録できるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: @user.nickname
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation 
      fill_in 'first-name', with: @user.family_name
      fill_in 'last-name', with: @user.first_name
      fill_in 'first-name-kana', with: @user.family_name_kana
      fill_in 'last-name-kana', with: @user.first_name_kana
      select '1989', from: 'user_birthday_1i'
      select '5', from: 'user_birthday_2i'
      select '18', from: 'user_birthday_3i'
      # サインアップボタンを押すとユーザーモデルのカウントが１上がること確認する
      expect{
        click_on("会員登録")
      }.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # ログアウトボタンが表示されていることを確認する
      expect(page).to have_content('ログアウト')
      # 新規登録ボタンやログインページへ遷移するボタンがないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # 誤ったユーザー情報を入力する
      fill_in 'nickname', with: ""
      fill_in 'email', with: ""
      fill_in 'password', with: ""
      fill_in 'password-confirmation', with: "" 
      fill_in 'first-name', with: ""
      fill_in 'last-name', with: ""
      fill_in 'first-name-kana', with: ""
      fill_in 'last-name-kana', with: ""
      select '--', from: 'user_birthday_1i'
      select '--', from: 'user_birthday_2i'
      select '--', from: 'user_birthday_3i'
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        click_on("会員登録")
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq "/users"
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しい情報を入力する
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      # ログインボタンを押す
      click_on("ログイン")
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # ログアウトボタンが表示されていることを確認する
      expect(page).to have_content('ログアウト')
      # 新規登録ボタンやログインボタンがないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインできないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページへ遷移する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'email', with: ""
      fill_in 'password', with: ""
      # ログインボタンを押す
      click_on("ログイン")
      # ログインページへ戻されることを確認する
      expect(current_path).to eq "/users/sign_in"
    end
  end
end