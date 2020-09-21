class ItemsController < ApplicationController
  def index
    @items = Item.order('created_at DESC')
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

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
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
end
