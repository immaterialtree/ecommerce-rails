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
    redirect_to root_path, notice: notice
  end

  def remove_item
    session[:cart] ||= []
    session[:cart].delete(params[:item])
    redirect_to cart_path, notice: "Item removido do carrinho."
  end

  def pay
    product_counts = (session[:cart] || []).each_with_object(Hash.new(0)) do |prod_id, counts|
      counts[prod_id.to_s] += 1
    end
    products = Product.where(:id.in => product_counts.keys)
    products.each do |product|
      count = product_counts[product.id.to_s] || 0
      product.update(stock: product.stock - count)
    end
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
