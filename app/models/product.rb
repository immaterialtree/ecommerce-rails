require 'bigdecimal'

class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :price, type: BigDecimal
  field :description, type: String
  field :stock, type: Integer
  field :image, type: String

  index({ name: 'text', description: 'text' })
end
