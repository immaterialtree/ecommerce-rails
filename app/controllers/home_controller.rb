class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    if params[:query].present?
      @products = Product.where("name LIKE #{params[:query]} OR description LIKE #{params[:query]}")
    else
      @products = Product.all
    end
  end
end
