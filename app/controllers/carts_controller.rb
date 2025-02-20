class CartsController < ApplicationController
  protect_from_forgery except: :process_payment

  def show
    @cart = cart_products || []
    @total = @cart.sum(&:price)
  end

  def add_item
    session[:cart] ||= {}
    if Product.exists?(params[:item])
      session[:cart][params[:item]] ||= 0
      session[:cart][params[:item]] += 1
      notice = "Item adicionado ao carrinho."
    else
      notice = "Item não encontrado."
    end
    redirect_to root_path, notice: notice
  end

  def remove_item
    session[:cart] ||= {}
    if session[:cart][params[:item]].to_i > 0
      session[:cart][params[:item]] -= 1
      session[:cart].delete(params[:item]) if session[:cart][params[:item]] <= 0
      notice = "Item removido do carrinho."
    else
      notice = "Item não encontrado no carrinho."
    end
    redirect_to cart_path, notice: notice
  end

  def delete_item
    session[:cart] ||= {}
    if session[:cart].delete(params[:item])
      notice = "Todos os itens do tipo foram removidos do carrinho."
    else
      notice = "Item não encontrado no carrinho."
    end
    redirect_to cart_path, notice: notice
  end

  def pay
    require 'mercadopago'

    @cart = cart_products || []
    @total = @cart.sum(&:price)
    if @cart.empty?
      redirect_to cart_path, alert: "Seu carrinho está vazio."
    else
      render :pay
    end
  end

  def process_payment
    require 'mercadopago'

    # Integração com Mercado Pago
    sdk = Mercadopago::SDK.new('TEST-6597116855860817-021309-046d3a9de12461f3a02bde0bcd24bd60-278204658')
    
    payment_data = {
      transaction_amount: params[:transaction_amount].to_f,
      token: params[:token],
      # description: "Compra de produtos",
      installments: params[:installments].to_i,
      payment_method_id: params[:payment_method_id],
      payer: {
        email: params[:payer][:email],
        identification: {
          type: params[:payer][:identification][:type],
          number: params[:payer][:identification][:number]
        },
      }
    }

    payment_response = sdk.payment.create(payment_data)
    payment = payment_response[:response]

    if payment['status'] == 'approved'
      clear_cart
      render json: { success: true, message: "Pagamento realizado com sucesso." }
    else
      render json: { success: false, message: "Falha no pagamento: #{payment}" }
    end
  end

  private
  def cart_products
    product_ids = session[:cart].keys || []
    existing_products = Product.where(:_id.in => product_ids)
    session[:cart].slice!(*existing_products.pluck(:id).map(&:to_s)) # atualiza a sessão com apenas os produtos existentes
    existing_products
  end

  private
  def clear_cart
    product_counts = session[:cart] || {}
    products = Product.where(:_id.in => product_counts.keys)
    products.each do |product|
      count = product_counts[product.id.to_s] || 0
      product.update(stock: product.stock - count)
    end
    session[:cart] = {}
  end
end
