class ItemsController < ApplicationController
  before_action :user_signed_check, only: [:new, :create]
  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :comment,
      :value,
      :category_id,
      :status_id,
      :delivery_fee_id,
      :area_id,
      :date_of_shipment_id,
      :image
    ).merge(user_id: current_user.id)
  end

  def user_signed_check
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
