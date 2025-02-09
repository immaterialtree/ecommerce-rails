class CartsController < ApplicationController
  def show
    @cart = cart_products
  end

def add_item
    session[:cart] ||= []
    if Product.exists?(params[:item])
        session[:cart] << params[:item]
        notice = "Item adicionado ao carrinho."
    else
        notice = "Item não encontrado."
    end
    redirect_back fallback_location: root_path, notice: notice
end

  def pay
    session[:cart] = [] # limpa o carrinho após pagamento
    redirect_to root_path, notice: "Pagamento realizado com sucesso."
  end

  private

def cart_products
    product_ids = session[:cart] || []
    existing_products = Product.where(id: product_ids)
    session[:cart] = existing_products.pluck(:id) # atualiza a sessão com apenas os produtos existentes
    existing_products
end
end
