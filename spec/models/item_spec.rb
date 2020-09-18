require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '#create' do
    before do
      @item = FactoryBot.build(:item)
    end

    describe '商品出品登録' do
      context '登録がうまくいくとき' do
        it '商品名、紹介文、画像、値段、カテゴリー、状態、配送料、発送元、発送までの日数が存在すれば登録できること' do
          expect(@item).to be_valid
        end
      end

      context '登録がうまくいかないとき' do
        context '商品名' do
          it 'nameが空では登録できないこと' do
            @item.name = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Name can't be blank")
          end
          it 'nameは40文字以内でなければ登録できないこと' do
            @item.name = Faker::Number.number(digits: 41)
            @item.valid?
            expect(@item.errors.full_messages).to include("Name is too long (maximum is 40 characters)")
          end
        end

        context '商品紹介文' do
          it 'commentが空では登録できないこと' do
            @item.comment = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Comment can't be blank")
          end
          it 'commentは1000文字以内でなければ登録できないこと' do
            @item.comment = Faker::Number.number(digits: 1001)
            @item.valid?
            expect(@item.errors.full_messages).to include("Comment is too long (maximum is 1000 characters)")
          end
        end

        context '商品画像' do
          it 'imageが空では登録できないこと' do
            @item.image = nil
            @item.valid?
            expect(@item.errors.full_messages).to include("Image can't be blank")
          end
        end

        context '商品価格' do
          it 'valueが空では登録できないこと' do
            @item.value = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Value can't be blank")
          end
          it 'valueの値は全角文字では登録できないこと' do
            @item.value = "１２３４５"
            @item.valid?
            expect(@item.errors.full_messages).to include("Value is not a number")
          end
          it 'valueの値は半角英字では登録できないこと' do
            @item.value = "abcdef"
            @item.valid?
            expect(@item.errors.full_messages).to include("Value is not a number")
          end
          it 'valueの値は300以上でなければ登録できないこと' do
            @item.value = 299
            @item.valid?
            expect(@item.errors.full_messages).to include("Value must be greater than or equal to 300")
          end
          it 'valueの値は9,999,999以内でなければ登録できないこと' do
            @item.value = 10000000
            @item.valid?
            expect(@item.errors.full_messages).to include("Value must be less than or equal to 9999999")
          end
        end

        context 'カテゴリー、状態、配送料、配送元、発送までの日数' do
          # カテゴリー
          it 'category_idが空では登録できないこと' do
            @item.category_id = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Category can't be blank")
          end
          it 'categoryが「---」(id:1)では登録できないこと' do
            @item.category_id = 1
            @item.valid?
            expect(@item.errors.full_messages).to include("Category must be other than 1")
          end
      
          # 商品状態
          it 'status_idが空では登録できないこと' do
            @item.status_id = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Status can't be blank")
          end
          it 'statusが「---」(id:1)では登録できないこと' do
            @item.status_id = 1
            @item.valid?
            expect(@item.errors.full_messages).to include("Status must be other than 1")
          end
      
          # 配送料
          it 'delivery_fee_idが空では登録できないこと' do
            @item.delivery_fee_id = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Delivery fee can't be blank")
          end
          it 'delivery_feeが「---」(id:1)では登録できないこと' do
            @item.delivery_fee_id = 1
            @item.valid?
            expect(@item.errors.full_messages).to include("Delivery fee must be other than 1")
          end
      
          # 配送元
          it 'area_idが空では登録できないこと' do
            @item.area_id = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Area can't be blank")
          end
          it 'areaが「---」(id:1)では登録できないこと' do
            @item.area_id = 1
            @item.valid?
            expect(@item.errors.full_messages).to include("Area must be other than 1")
          end
      
          # 発送までの日数
          it 'date_of_shipment_idが空では登録できないこと' do
            @item.date_of_shipment_id = ""
            @item.valid?
            expect(@item.errors.full_messages).to include("Date of shipment can't be blank")
          end
          it 'date_of_shipmentが「---」(id:1)では登録できないこと' do
            @item.date_of_shipment_id = 1
            @item.valid?
            expect(@item.errors.full_messages).to include("Date of shipment must be other than 1")
          end
        end
      end
    end
  end
end
