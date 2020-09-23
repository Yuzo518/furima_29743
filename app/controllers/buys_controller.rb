class BuysController < ApplicationController

  def index
    @item = Item.find(params[:item_id])
  end

  def new
  end

  def create
    @buy = Buy.new(item_id: buy_params[:item_id], user_id: current_user.id, token: buy_params[:token])
    if @buy.valid?
      pay_item
      @buy.save
      return redirect_to root_path
    else
      return 'index'
    end
  end

  private

  def buy_params
    params.permit(:item_id, :token)
  end

  def pay_item
    # buy_paramsメソッドより取得したitem_idより指定のitemを取得する
    item = Item.find(buy_params[:item_id])
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: item.value,
      card: buy_params[:token],
      currency:'jpy'
    )
  end

end
