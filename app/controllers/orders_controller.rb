class OrdersController < ApplicationController
  def index
    @orders = Order.where(user_id: current_user.id)
  end
end
