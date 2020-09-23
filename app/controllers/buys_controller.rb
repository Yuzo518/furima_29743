class BuysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit]
  before_action :move_index_check, only: [:index]

  def index
    @item = Item.find(params[:item_id])
    @buy = BuyAddress.new
  end

  def new
  end

  def create
    @buy = BuyAddress.new(buy_params)
    if @buy.valid?
      pay_item
      @buy.save
      redirect_to root_path
    else
      @item = Item.find(params[:item_id])
      render 'index'
    end
  end

  private

  def buy_params
    params.permit(
      :token,
      :item_id,
      :post_code,
      :prefectures_id,
      :municipal_district,
      :house_number,
      :building_name,
      :phone_number
    ).merge(user_id: current_user.id)
  end

  def pay_item
    item = Item.find(buy_params[:item_id])
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: item.value,
      card: buy_params[:token],
      currency: 'jpy'
    )
  end

  def move_index_check
    item = Item.find(params[:item_id])
    # もしその商品が購入済み（その商品テーブルのIDが購入テーブルのitem_idに存在していたら）
    # もしくは出品したユーザー（商品のユーザーIDとログインしているユーザーのIDが一致）
    if Buy.find_by(item_id: params[:item_id])
      redirect_to root_path
    elsif item.user_id == current_user.id
      redirect_to root_path
    end
  end
end
