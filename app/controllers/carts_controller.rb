class CartsController < ApplicationController
  def show
    @cart = cart_products || []
    @total = @cart.sum(&:price)
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
    require 'mercadopago'

    # Integração com Mercado Pago
    sdk = Mercadopago::SDK.new('6597116855860817')
    payment_data = {
      transaction_amount: @total,
      token: params[:token],
      description: 'Descrição do pagamento',
      installments: 1,
      payment_method_id: 'visa',
      payer: {
        email: 'payer_email@example.com'
      }
    }
    payment_response = sdk.payment.create(payment_data)
    payment = payment_response[:response]

    if payment[:status] == 'approved'
      clear_cart
      redirect_to root_path, notice: "Pagamento realizado com sucesso."
    else
      redirect_to cart_path, alert: "Falha no pagamento: #{payment[:status_detail]}"
    end
  end

  private
  def cart_products
    product_ids = session[:cart] || []
    existing_products = Product.where(:_id.in => product_ids)
    session[:cart] = existing_products.pluck(:id).map(&:to_s) # atualiza a sessão com apenas os produtos existentes
    existing_products
  end

  private
  def clear_cart
    product_counts = (session[:cart] || []).each_with_object(Hash.new(0)) do |prod_id, counts|
      counts[prod_id.to_s] += 1
    end
    products = Product.where(:_id.in => product_counts.keys)
    products.each do |product|
      count = product_counts[product.id.to_s] || 0
      product.update(stock: product.stock - count)
    end
  end
end
