require 'rails_helper'

RSpec.describe BuyAddress, type: :model do
  describe '#create ' do
    before do
      @buy_address = FactoryBot.build(:buy_address)
    end

    context '登録がうまくいくとき' do
      it '全ての値が正しく入力されていれば保存できる' do
        expect(@buy_address).to be_valid
      end
      it 'building_nameが存在しなくても保存できる' do
        @buy_address.building_name = nil
        expect(@buy_address).to be_valid
      end
    end

    context '登録がうまくいかないとき' do
      it 'tokenが生成できていないと保存できないこと' do
        @buy_address.token = nil
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include("Token can't be blank")
      end
      it 'post_codeが存在しないと保存できないこと' do
        @buy_address.post_code = nil
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include("Post code can't be blank")
      end
      it 'post_codeにハイフン（-）が含まれていないと保存できないこと' do
        @buy_address.post_code = '12345678'
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include('Post code is invalid. Include hyphen(-)')
      end
      it 'post_codeは半角数字でないと保存できないこと' do
        @buy_address.post_code = '１２３ー４５６７'
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include('Post code is invalid. Include hyphen(-)')
      end
      it 'post_codeは（数字3桁）（-）（数字4桁）の形式でないと保存できないこと' do
        @buy_address.post_code = '1234-567'
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include('Post code is invalid. Include hyphen(-)')
      end
      it 'prefectures_idが存在しないと保存できないこと' do
        @buy_address.prefectures_id = nil
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include("Prefectures can't be blank")
      end
      it 'prefectures_idが『---』(id:1)を選択したとき保存できないこと' do
        @buy_address.prefectures_id = 1
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include("Prefectures can't be blank")
      end
      it 'municipal_districtが存在しないと保存できないこと' do
        @buy_address.municipal_district = nil
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include("Municipal district can't be blank")
      end
      it 'house_numberが存在しないと保存できないこと' do
        @buy_address.house_number = nil
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include("House number can't be blank")
      end
      it 'phone_numberが存在しないと保存できないこと' do
        @buy_address.phone_number = nil
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが半角数字でないと保存できないこと' do
        @buy_address.phone_number = '０９０１２３４５６７８'
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include('Phone number is invalid. Input half-width characters')
      end
      it 'phone_numberはハイフン（-）が含まれていると保存できないこと' do
        @buy_address.phone_number = '090-1234-5678'
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include('Phone number is invalid. Input half-width characters')
      end
      it 'phone_numberは11桁以内でないと保存できないこと' do
        @buy_address.phone_number = '090123456789'
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include('Phone number is invalid. Input half-width characters')
      end
      it 'phone_numberは10桁以上でないと保存できないこと' do
        @buy_address.phone_number = '090123456'
        @buy_address.valid?
        expect(@buy_address.errors.full_messages).to include('Phone number is invalid. Input half-width characters')
      end
    end
  end
end
