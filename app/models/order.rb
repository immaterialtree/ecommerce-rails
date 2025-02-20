class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  field :total_price, type: BigDecimal
  field :products, type: Array

  belongs_to :user

  validates :total_price, presence: true
  validates :products, presence: true
end