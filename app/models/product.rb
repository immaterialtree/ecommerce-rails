class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :price, type: Decimal
  field :description, type: String
  field :stock, type: Integer
  field :image, type: String
end
