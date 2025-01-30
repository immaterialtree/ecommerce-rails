5.times do |i|
    Product.create!(name: "Product ##{i}", description: "A product.", price: 39.90 + i*10, stock: 50 - i, image: "https://cdn-icons-png.freepik.com/256/6935/6935960.png?semt=ais_hybrid")
  end
  puts "Produtos criados"