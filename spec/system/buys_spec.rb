require 'rails_helper'

RSpec.describe "商品購入", type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
    @buy = FactoryBot.build(:buy_address)
  end
  context '商品購入ができるとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の購入ができる' do
      # 商品１のユーザーでログインする
      sign_in(@item1.user)
      # 商品２の詳細ページへ遷移する
      visit item_path(@item2)
      # 「購入画面に進む」ボタンが表示されていることを確認する
      expect(page).to have_content('購入画面に進む')
      # 商品１の購入ページへ遷移する
      visit item_buys_path(@item2)
      # 購入内容を入力する
      fill_in 'card-number', with:'4242424242424242'
      fill_in 'card-exp-month', with:'3'
      fill_in 'card-exp-year', with:'23'
      fill_in 'card-cvc', with:'123'
      fill_in 'postal-code', with:@buy.post_code
      select "#{Area.find(@buy.prefectures_id).name}", from: 'prefecture'
      fill_in 'city', with:@buy.municipal_district
      fill_in 'addresses', with:@buy.house_number
      fill_in 'building', with:@buy.building_name
      fill_in 'phone-number', with:@buy.phone_number
      # 購入したらBuyテーブルとAddressテーブルのカウントが１上がることを確認する
      expect{
        click_on('購入')
        sleep 3
      }.to change { Buy.count }.by(1).and change { Address.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページの商品２の画像に「Sold Out!!」が表示されていることを確認する
      expect(page).to have_selector '.sold-out', text: 'Sold Out!!'
      # 商品２の詳細ページへ遷移する
      visit item_path(@item2)
      # 詳細ページの画像に「Sold Out!!」が表示されていることを確認する
      expect(page).to have_selector '.sold-out', text: 'Sold Out!!'
      # 「購入画面に進む」ボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # ログアウトする
      click_on('ログアウト')
      # 商品２のユーザーでログインする
      sign_in(@item2.user)
      # 商品２の詳細ページへ遷移する
      visit item_path(@item2)
      # 「商品の編集」ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
      # 「削除」ボタンがないことを確認する
      expect(page).to have_no_content('削除')
    end
  end
  context '商品購入ができないとき' do
    it 'ログインしたユーザーは自分で出品した商品の購入ページへ遷移できない' do
      # 商品１のユーザーでログインする
      sign_in(@item1.user)
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「購入画面に進む」ボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
    end
    it '未ログインのユーザーは商品の購入ページへ遷移できない' do
      # トップページへ遷移する
      visit root_path
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「購入画面に進む」ボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
    end
  end
end
