json.extract! product, :id, :name, :price, :description, :stock, :image, :created_at, :updated_at
json.url product_url(product, format: :json)
