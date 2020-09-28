require 'rails_helper'

RSpec.describe "商品出品", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '商品出品ができるとき' do
    it 'ログインしたユーザーは商品出品できる' do
      # ログインする
      sign_in(@user)
      # 商品出品ページへのリンクがある
      expect(page).to have_content('出品する')
      # 商品出品ページに移動する
      visit new_item_path
      # 出品する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('item[image]', image_path)
      # 商品情報を入力する
      fill_in 'item-name', with:@item.name
      fill_in 'item-info', with:@item.comment
      select "#{Category.find(@item.category_id).name}", from: 'item-category'
      select "#{Status.find(@item.status_id).name}", from: 'item-sales-status'
      select "#{DeliveryFee.find(@item.delivery_fee_id).name}", from: 'item-shipping-fee-status'
      select "#{Area.find(@item.area_id).name}", from: 'item-prefecture'
      select "#{DateOfShipment.find(@item.date_of_shipment_id).name}", from: 'item-scheduled-delivery'
      fill_in 'item-price', with: @item.value
      # 価格を入力すると販売手数料(10%)が表示される
      tax = (@item.value*0.1).floor
      expect(page).to have_selector '#add-tax-price', text: "#{tax}"
      # 価格を入力すると販売利益が表示される
      profit = (@item.value*0.9).floor
      expect(page).to have_selector '#profit', text: "#{profit}"
      # 出品ボタンを押すとitemモデルのカウントが1上がることを確認する
      expect{
        click_on('出品する')
      }.to change { Item.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページに先ほど出品した商品が存在することを確認する（画像・商品名・値段）
      expect(page).to have_selector("img[src$='test_image.png']")
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.value)
    end
  end
  context '商品出品ができないとき' do
    it 'ログインしていないと商品出品ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 商品出品ページへのリンクがある
      expect(page).to have_content('出品する')
      # 出品ボタンを押したらログインページへ遷移する
      visit new_item_path
      expect(current_path).to eq "/users/sign_in"
    end
  end
end

RSpec.describe '商品編集', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品編集ができるとき' do
    it 'ログインしたユーザーは自分が出品した商品の編集ができる' do
      # 商品１で投稿したユーザーでログインする
      sign_in(@item1.user)
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「商品の編集」ボタンがあることを確認する
      expect(page).to have_content('商品の編集')
      # 商品１の編集ページへ遷移する
      visit edit_item_path(@item1)
      # 変更する画像を定義する
      image_path = Rails.root.join('public/images/test_image1.png')
      # 画像選択フォームに画像を添付する
      attach_file('item[image]', image_path)
      # 変更内容
      item_name = "New#{@item1.name}"
      item_comment = "New#{@item1.comment}"
      item_category = Category.find(3).name
      item_status = Status.find(3).name
      item_delivery_fee = DeliveryFee.find(3).name
      item_area = Area.find(3).name
      item_date_of_shipment = DateOfShipment.find(3).name
      item_value = @item1.value + 1000
      # 商品内容を編集できる
      fill_in 'item-name', with:"#{item_name}"
      fill_in 'item-info', with:"#{item_comment}"
      select "#{item_category}", from: 'item-category'
      select "#{item_status}", from: 'item-sales-status'
      select "#{item_delivery_fee}", from: 'item-shipping-fee-status'
      select "#{item_area}", from: 'item-prefecture'
      select "#{item_date_of_shipment}", from: 'item-scheduled-delivery'
      fill_in 'item-price', with: item_value
      # 価格を入力すると販売手数料(10%)が表示される
      tax = (item_value*0.1).floor
      expect(page).to have_selector '#add-tax-price', text: "#{tax}"
      # 価格を入力すると販売利益が表示される
      profit = (item_value*0.9).floor
      expect(page).to have_selector '#profit', text: "#{profit}"
      # 編集してもitemモデルのカウントが変わらないことを確認する
      expect{
        click_on('変更する')
      }.to change { Item.count }.by(0)
      # 商品１の詳細ページへ遷移する
      expect(current_path).to eq item_path(@item1)
      # 詳細ページに先ほど出品した商品が存在することを確認する（各項目）
      expect(page).to have_selector("img[src$='test_image1.png']")
      expect(page).to have_content("#{item_name}")
      expect(page).to have_content("#{item_comment}")
      expect(page).to have_content("¥ #{item_value}")
      expect(page).to have_content("#{item_category}")
      expect(page).to have_content("#{item_status}")
      expect(page).to have_content("#{item_delivery_fee}")
      expect(page).to have_content("#{item_area}")
      expect(page).to have_content("#{item_date_of_shipment}")
    end
  end
  context '商品編集ができないとき' do
    it 'ログインしたユーザーは自分以外の人が出品した商品の編集ページに遷移できない' do
      # 商品２で出品したユーザーでログインする
      sign_in(@item2.user)
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「商品の編集」ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
    end
    it 'ログインしていないユーザーは商品の編集ページに遷移できない' do
      # トップページへ遷移する
      visit root_path
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「商品の編集」ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
    end
  end
end

RSpec.describe '商品削除', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.build(:item)
  end
  context '商品の削除ができるとき' do
    it 'ログインしたユーザーは自分が出品した商品の削除ができる' do
      # 商品１を出品したユーザーでログインする
      sign_in(@item1.user)
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「削除」ボタンがあることを確認する
      expect(page).to have_content('削除')
      # 商品を削除するとitemモデルのカウントが１減ることを確認する
      expect{
        click_on('削除')
      }.to change { Item.count }.by(-1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # トップページには商品１の内容が存在しないことを確認する（画像・商品名・値段）
      expect(page).to have_no_selector("img[src$='test_image.png']")
      # トップページに先ほど出品した商品が存在しないことを確認する（商品名）
      expect(page).to have_no_content(@item1.name)
      # トップページに先ほど出品した商品が存在しないことを確認する（値段）
      expect(page).to have_no_content(@item1.value)
    end
  end
  context '商品の削除ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の削除はできない' do
      @item2.save
      # 商品２を出品したユーザーでログインする
      sign_in(@item2.user)
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「削除」ボタンがないことを確認する
      expect(page).to have_no_content('削除')
    end
    it 'ログインしていないと商品の削除はできない' do
      # トップページへ遷移する
      visit root_path
      # 商品１の詳細ページへ遷移する
      visit item_path(@item1)
      # 「削除」ボタンがないことを確認する
      expect(page).to have_no_content('削除')
    end
  end
end

RSpec.describe '商品詳細表示', type: :system do
  before do
    @item = FactoryBot.create(:item)
  end
  it 'ログインしたユーザーは商品詳細ページに遷移できる' do
    # ログインする
    sign_in(@item.user)
    # 商品詳細ページへ遷移する
    visit item_path(@item)
    # 商品詳細ページに商品の内容が表示されている
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_content("#{@item.name}")
    expect(page).to have_content("#{@item.comment}")
    expect(page).to have_content("¥ #{@item.value}")
    expect(page).to have_content("#{DeliveryFee.find(@item.delivery_fee_id).name}")
    expect(page).to have_content("#{DateOfShipment.find(@item.date_of_shipment_id).name}")
    expect(page).to have_content("#{Status.find(@item.status_id).name}")
    expect(page).to have_content("#{Area.find(@item.area_id).name}")
    expect(page).to have_content("#{Category.find(@item.category_id).name}")
  end
  it '未ログインユーザーは商品詳細ページに遷移できる' do
    # トップページへ遷移する
    visit root_path
    # 商品詳細ページへ遷移する
    visit item_path(@item)
    # 商品詳細ページに商品の内容が表示されている
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_content("#{@item.name}")
    expect(page).to have_content("#{@item.comment}")
    expect(page).to have_content("¥ #{@item.value}")
    expect(page).to have_content("#{DeliveryFee.find(@item.delivery_fee_id).name}")
    expect(page).to have_content("#{DateOfShipment.find(@item.date_of_shipment_id).name}")
    expect(page).to have_content("#{Status.find(@item.status_id).name}")
    expect(page).to have_content("#{Area.find(@item.area_id).name}")
    expect(page).to have_content("#{Category.find(@item.category_id).name}")
  end
end