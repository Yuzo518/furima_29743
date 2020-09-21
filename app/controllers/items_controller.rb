class ItemsController < ApplicationController
  before_action :move_index, only: [:edit, :update]
  before_action :item_find, only: [:show, :edit, :update]
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
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path
    else
      render :edit
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

  def move_index
    item = Item.find(params[:id])
    redirect_to root_path if current_user.id != item.user_id
  end

  def item_find
    @item = Item.find(params[:id])
  end
end
