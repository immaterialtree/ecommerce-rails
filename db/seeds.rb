nouns = ["Cadeira", "Mesa", "Computador", "Livro", "Caneta"]
adjectives = ["Super", "Grande", "Rápido", "Novo", "Antigo"]
images = [
  "https://cdn-icons-png.freepik.com/256/6935/6935960.png?semt=ais_hybrid",
  "https://cdn-icons-png.flaticon.com/512/3573/3573045.png",
  "https://cdn-icons-png.flaticon.com/512/3159/3159066.png"
]

5.times do |i|
  name = "#{nouns.sample} #{adjectives.sample}"
  Product.create!(name: name, description: "A product.", price: 39.90 + i*10, stock: 50 - i, image: images.sample)
end
puts "Produtos criados"
