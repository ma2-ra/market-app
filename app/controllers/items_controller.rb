class ItemsController < ApplicationController
  before_action :authenticate_user! , only: [:new]
  before_action :set_item, only:[:destroy,:edit,:update]
  def index
    @items = Item.includes(:images).order("created_at DESC")
  end

  def new
    @item = Item.new
    @item.images.build
  end

  def create
    @item = Item.new(item_params)
    @item.seller_id = current_user.id
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    if @item.destroy
      redirect_to index_more_new_page_items_path, notice: "商品を削除しました。" 
    else
      render :index_more_new_page, notice: "商品を削除できませんでした。" 
    end
  end


  def show
    @item = Item.find(params[:id])
    # impressionist(@item)
    # , nil, :unique => [:session_hash]
    # @page_views = @item.impressionist_count
  end

  def index_more_new_page
    @items = Item.includes(:images).order("created_at DESC").page(params[:page]).per(12)
  end

  def edit
    
  end

  def update
    
    @item.update(item_params)
    if @item.update
      redirect_to root_path
    else
      render :edit
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :category_id,:brand_name, :item_condition,:shipping_payer,:shipping_from_area,:shipping_duration,:price,:user_id, images_attributes: [:image, :id, :_destroy])  end
  end
  def set_item
    @item = Item.find(params[:id])
  end

# if @item.save
#   params[:images]['image'].each do |a|
#     @item_image = @item.images.create!(image: a)
#   end
#   redirect_to root_path, notice: '出品しました。'
# else
#   render :new
# end