class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    # require 'pry'; binding.pry
    if Restaurant.find(params[:id]).user == current_user
      @restaurant = Restaurant.find(params[:id])
    else
      flash[:notice] = "Cannot Edit a Restaurant you don't own"
      redirect_to restaurants_path
    end

  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    if Restaurant.find(params[:id]).user == current_user
      @restaurant = Restaurant.find(params[:id])
      name = @restaurant.name
      @restaurant.destroy
      flash[:notice] = "#{name} deleted successfully"
      redirect_to '/restaurants'
    else
      flash[:notice] = "Cannot Delete a Restaurant you don't own"
      redirect_to '/restaurants'
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end

end
