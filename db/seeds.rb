# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"
require "net/http"

User.destroy_all
Costume.destroy_all

users = []
10.times do |i|
  users << User.create!(
    first_name: "User#{i + 1}",
    last_name: "Test",
    email: "user#{i + 1}@example.com",
    password: "password"
  )
end


def create_costume( name:, size:, description:, price:, category:, user:, image_url:, wearers: [], extra_image_urls: [] )
  wearer_string = wearers.join(", ")

  begin
    downloaded_image = URI.open( image_url )

    costume = Costume.create!(
      name: name,
      size: size,
      description: description,
      price_per_day: price,
      category: category,
      user: user,
      wearer_list: wearers,
      image: image_url
    )

    # costume.photos.attach(
    #   io: downloaded_image,
    #   filename: "#{name.parameterize}.jpg",
    #   content_type: downloaded_image.content_type || "image/jpeg"
    # )

    # Attach main image to photo (cover)
    costume.photo.attach(
      io: downloaded_image,
      filename: "#{name.parameterize}-main.jpg",
      content_type: downloaded_image.content_type || "image/jpeg"
    )

    # # Attach main image to photos gallery too (optional but common)
    # costume.photos.attach(
    #   io: downloaded_image,
    #   filename: "#{name.parameterize}-main.jpg",
    #   content_type: downloaded_image.content_type || "image/jpeg"
    # )

    # NEW: Attach extra images to costume.photos
    extra_image_urls.each_with_index do |url, idx|
      begin
        extra_image = URI.open(url)
        costume.photos.attach(
          io: extra_image,
          filename: "#{name.parameterize}-extra#{idx + 1}.jpg",
          content_type: extra_image.content_type || "image/jpeg"
        )
      rescue => e
        puts "Error attaching extra image #{idx + 1} for #{name} - #{e.message}"
      end
    end

    puts "Created: #{name}"
  rescue OpenURI::HTTPError, SocketError, OpenSSL::SSL::SSLError => e
    puts "Image not reachable, skipping image for #{name} - #{e.message}"
    costume = Costume.create!(
      name: name,
      size: size,
      description: description,
      price_per_day: price,
      category: category,
      user: user,
      wearer_list: wearers,
      image: image_url
    )
  end
end

puts "Creating costumes..."

popular_costumes = [
  ["Harry Potter Robe", 40, "Hogwarts uniform with Gryffindor badge and wand.", 35.0, "https://s7.orientaltrading.com/is/image/OrientalTrading/14277527?$PDP_VIEWER_IMAGE$", ["https://spirit.scene7.com/is/image/Spirit/01509256-a?$Detail$"], ["Man", "Boy"]],
  ["Vampire Cape", 48, "Classic Dracula-style vampire costume with red-lined cape.", 30.0, "https://s7.orientaltrading.com/is/image/OrientalTrading/14401132?$PDP_VIEWER_IMAGE$", ["https://www.moderngentlemanmagazine.com/wp-content/uploads/2024/08/classic-dracula-outfit-idea-650x811.jpg"], ["Man", "Boy"]],
  ["Witch Outfit", 38, "Black velvet witch costume with pointy hat.", 25.0, "https://i.pinimg.com/736x/e9/08/c1/e908c13f3b3d1becf48e69b8e88dd39a.jpg", ["https://www.tipsyelves.com/cdn/shop/files/womens-halloween-witch-costume-lifestyle-01.jpg?v=1692730609"], ["Woman", "Girl"]],
  ["Princess Dress", 36, "Pink royal princess gown with glittering skirt.", 32.0, "https://www.victoriandancer.com/images/Disney-Dresses/DC-23/img.jpg", ["https://images.halloweencostumes.com/products/91812/1-1/adult-disney-charlotte-princess-and-the-frog-costume.jpg"], ["Woman", "Girl"]],
  ["Pirate Costume", 52, "Swashbuckling pirate with hat, eyepatch, and coat.", 28.0, "https://i0.wp.com/fabrickated.com/wp-content/uploads/2014/05/piratesof-caribean.jpg", ["https://www.costumebay.com.au/images/thumbs/0035533_captains-charm-womens-pirate-costume_550.jpeg"],  ["Man", "Boy"]],
  ["Clown Suit", 44, "Colorful clown outfit with oversized shoes and nose.", 22.0, "https://i.pinimg.com/736x/a6/fa/3e/a6fa3eff799696732f65fb766d0f1153.jpg", ["https://www.partydudes.co.nz/cdn/shop/products/clown-plus-costume.jpg?v=1630799107"],  ["Man", "Boy"]],
  ["Ghost Sheet", 46, "Simple ghost costume with eye holes – classic and spooky.",15.0, "https://i.pinimg.com/736x/b7/71/51/b77151e894cfa63dc5e6799d0c5e3348.jpg", ["https://miro.medium.com/v2/resize:fit:1400/0*iJGWBcGQlCJgvva9"],  ["Man", "Boy"]],
  ["Cat Onesie", 42, "Comfy black cat onesie with ears and tail.", 18.0, "https://static1.funidelia.com/532328-f6_big2/cat-onesie-costume-for-adults.jpg", ["https://www.partydelights.ie/media/catalog/product/cache/28f393c4da9e0eeb58ec314c5830eabd/4/_/4_s1jjfridifui5p0h.jpg"], ["Woman", "Girl"]],
  ["Cowboy Outfit", 54, "Wild west cowboy with hat, vest, and boots.", 27.0, "https://i.mmo.cm/is/image/mmoimg/mw-product-max/cowboy-vest-chaps-black--mw-117289-1.jpg", ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR527wdyVDrXs1_I9r4wlQ8JTyZwFlhhhpxOg&s"], ["Man", "Boy"]],
  ["Santa Claus", 52, "Red jolly suit", 40.0, "https://www.costumesforsanta.com/images/com_hikashop/upload/regal-red-velvet-santa-suit.jpg", ["https://cdn.christmaswarehouse.com.au/cache/dd17b500e8780b51f632e5a51253f6f3_thumb.png"], ["https://media-cldnry.s-nbcnews.com/image/upload/rockcms/2022-12/married-to-santa-claus-zz-221212-03-c8be3c.jpg"], ["Man", "Boy"]]
]

superhero_costumes = [
  ["Samurai Warrior", 50, "Authentic-looking samurai costume with armor pieces.", 40.0, "https://dallasvintageshop.com/wp-content/uploads/2018/07/Photo-Apr-16-1-15-37-PM.jpg", ["https://m.china-cart.com/u/199/3035125/Japanese_Ancient_Warrior_Black_Armor_and_Helmet_Traditional_Asian_Japan_General_Samurai_Costumes_Complete_Set_for_Men.jpg"], ["Man", "Boy"] ],
  ["Batman", 48, "Dark night costume", 35.0, "https://www.by-the-sword.com/images/product/large/60-217491.jpg", ["https://spirit.scene7.com/is/image/Spirit/01628445-a?wid=640&hei=640&fmt=webp"], ["Man", "Boy"] ],
  ["Wonder Woman", 36, "Amazon warrior outfit", 32.0, "https://static1.funidelia.com/475719-f6_big2/wonder-woman-costume.jpg", ["https://i5.walmartimages.com/seo/Wonder-Woman-Toddler-Costume_b88b22e2-22d2-4470-ac62-9453d81c1466.c5d42dee5a5f32ebfb97524c2e862911.jpeg"], ["Woman", "Girl"] ],
  ["Spider Man", 38, "Web-slinger suit", 30.0, "https://www.previewsworld.com/SiteImage/MainImage/STK472074", ["https://hasthip.com/cdn/shop/files/718dsDAHFsL_10a3d186-2897-487a-a4c5-04bbabf1d244.jpg?v=1732793824"], ["Man", "Boy"] ],
  ["Hulk", 54, "Green muscle suit", 28.0, "https://i.pinimg.com/736x/7b/9a/1a/7b9a1a57dd6ad78f23b3be10a1698171.jpg", ["https://rukminim2.flixcart.com/image/704/844/xif0q/kid-costume-wear/x/l/n/2-3-years-urika207-urika-original-imagzqye92u96nac.jpeg?q=90&crop=false"], ["Man", "Boy"] ],
  ["Iron Man", 44, "Armored red and gold suit", 40.0, "https://joetoyss.com/cdn/shop/files/20231018152212_1200x.jpg?v=1697614106", ["https://pennypinchercostumesinc.com/wp-content/uploads/2024/02/Ironman-costume-768x1024.jpg"], ["Man", "Boy"] ],
  ["Cat Woman", 36, "Sleek and seductive", 29.0, "https://cdn11.bigcommerce.com/s-7k7lbbk7jr/images/stencil/1280x1280/products/23552/34345/media__40562.1657317351.jpg?c=1", [], ["Woman", "Girl"] ],
  ["Captain America", 46, "Stars and stripers costume", 34.0, "https://i.pinimg.com/736x/5d/3b/a0/5d3ba046ff5bdc94db6549ce1aecfb87.jpg", ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6RnoJFnvs4jlGXfPCSzK4MzRDjDFjgHBrEw&s"], ["Man", "Boy"] ],
  ["Superman", 50, "Blue and red superhero suit", 33.0, "https://images.fun.com/media/159/superman/adult-superman-costume.jpg", ["https://dallasvintageshop.com/wp-content/uploads/2022/05/Photo-Jun-21-6-02-50-PM-1.jpg"], ["Man", "Boy"] ],
  ["Thor", 48, "God and thunder outfit", 37.0, "https://images.fun.com/media/159/thor/thor-costume-adult.png", ["https://outlettrends.s3.us-east-2.amazonaws.com/wp-content/uploads/2023/09/16004853/45548-d2220a.jpeg"], ["Man", "Boy"] ]
]

anime_costumes = [
  ["Goku", 42, "Authentic Dragonball  Z Goku costume", 40.0, "https://www.gcosplay.com/cdn/shop/products/1_3320ca12-8582-4b38-9156-fe55f8886f74.jpg?v=1678257749", ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0LwHMjg5WRjMFrLHG34g5oGG-Wb4111TB7A&s"], ["Man", "Boy"] ],
  ["Levi", 38, "Survey corps uniform", 35.0, "https://media.cosmanles.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/3/7/3704-_2_.jpg", ["https://www.cosplayclass.com/wp-content/uploads/2016/10/Attack-on-Titan-Levi-Ackerman-Cosplay-Costume-cos12881-1.jpg"], ["Man", "Boy"] ],
  ["Naruto", 40, "Classic orange ninja jumpsuit", 38.0, "https://elka.ua/image/cache/catalog/Partners/masochka/man/mk-vk-1764-1-1000x1400.jpg", ["https://cdn11.bigcommerce.com/s-7k7lbbk7jr/images/stencil/1280x1280/products/24543/37156/SMQ071__55649.1697474834.jpg?c=1"], ["Man", "Boy"] ],
  ["Nezuko", 36, "Demon Slayer's Nezuko kamado kimono style", 37.0, "https://www.ubuy.co.it/productimg/?image=aHR0cHM6Ly9tLm1lZGlhLWFtYXpvbi5jb20vaW1hZ2VzL0kvNTFqN0RpYUFTRkwuX0FDX1VMMTAwMF8uanBn.jpg", ["https://www.animeclo.com/cdn/shop/files/nezuko2_2048x.jpg?v=1751991503"], ["Woman", "Girl"] ],
  ["Ichigo", 44, "Bleach's Ichigo Kurosaki shinigami ", 36.0, "https://cosplayware.s3.amazonaws.com/wp-content/uploads/2023/03/10101704/Anime-Bleach-Ichigo-Kurosaki-Coat-Pants-Dress-Cosplay-Costume-Halloween-Uniform-Death-cos-Kurosaki-Ai-Universal.jpg", ["https://assets.kogan.com/images/catchcostume/CCU-Bleach2-S/1-cb0fc616d6-s-l800.jpg?auto=webp&bg-color=fff&canvas=753%2C502&fit=bounds&height=502&quality=90&width=753"], ["Man", "Boy"] ],
  ["Deku", 42, "My Hero Academia's Izuku Midoriya hero", 39.0, "https://www.cosplayclan.com/cdn/shop/products/1_72311e68-0d57-4567-9e7b-a166f9ed02e3.jpg?v=1647248057", ["https://www.dhresource.com/webp/m/0x0/f2/albu/g20/M01/98/E1/rBVaqGFOztKAZACIAACToLeFKMU593.jpg"], ["Man", "Boy"] ],
  ["Tanjiro", 40, "Demon Slayer's Tanjiro Kamado", 38.0, "https://images-na.ssl-images-amazon.com/images/I/61BTSRav7dL._UL500_.jpg", ["https://www.cosrea.com/cdn/shop/products/cosrea-a-e-demon-slayer-takeo-kamado-cosplay-costume-15187311362103.png?v=1601441508"], ["Man", "Boy"] ],
  ["Anya", 38, "Spy x Family's Anya fonger pink school dress", 33.0, "https://hobbymaniaz.com.au/cdn/shop/products/O1CN017oDgdx1EyrVu1NsQI__950890421-0-cib.jpg?v=1660217030", ["https://m.media-amazon.com/images/I/618ZrmgGk6L._AC_SL1500_.jpg"], ["Woman", "Girl"] ],
  ["Inuyasha", 42, "Inuyasha's iconic kimono style rob", 37.0, "https://wickedhalloweencostumes.com/cdn/shop/files/H8a28d925d88d41fb87f9aea97febe373j.jpg_720x720q50_1200x1200.webp?v=1700442802", ["https://images-na.ssl-images-amazon.com/images/I/51FsqTj2q0L._SS400_.jpg"], ["Man", "Boy"] ],
  ["Sailor Moon", 40, "Classic Sailor Moon sailor fuku", 34.0, "https://aliceincosplayland.com/wp-content/uploads/2019/10/Super-Sailor-Moon-2.jpg", ["https://www.costumesinaustralia.com.au/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/l/z/lz8675pink_3.jpg"], ["Woman", "Girl"] ]

]

(popular_costumes + superhero_costumes + anime_costumes).each_with_index do |(name, size, desc, price, url, extra_urls, wearers), i|
  category = if i < popular_costumes.size
    "Popular"
  elsif i < (popular_costumes.size + superhero_costumes.size)
    "Superhero"
  else
    "Anime"
  end

  user = users[i % users.size]

create_costume(
  name: name,
  size: size,
  description: desc,
  price: price,
  category: category,
  user: users[i % users.size],
  image_url: url,
  extra_image_urls: extra_urls,
  wearers: wearers
)
end

puts "Seeding finish!"


user1 = User.create!(first_name: "Alice", last_name: "Tanaka", email: "alice@example.com", password: "password")
user2 = User.create!(first_name: "Ben", last_name: "Yamada", email: "ben@example.com", password: "password")
user3 = User.create!(first_name: "Clara", last_name: "Ito", email: "clara@example.com", password: "password")
user4 = User.create!(first_name: "David", last_name: "Suzuki", email: "david@example.com", password: "password")
user5 = User.create!(first_name: "Emma", last_name: "Kobayashi", email: "emma@example.com", password: "password")
user6 = User.create!(first_name: "Felix", last_name: "Matsuda", email: "felix@example.com", password: "password")
user7 = User.create!(first_name: "Grace", last_name: "Ono", email: "grace@example.com", password: "password")
user8 = User.create!(first_name: "Hiro", last_name: "Fujimoto", email: "hiro@example.com", password: "password")
user9 = User.create!(first_name: "Isabelle", last_name: "Takahashi", email: "isabelle@example.com", password: "password")
user10 = User.create!(first_name: "Jack", last_name: "Morita", email: "jack@example.com", password: "password")

# costumes = [
#   {
#     name: "Vampire Cape",
#     size: "48",
#     description: "Classic Dracula-style vampire costume with red-lined cape.",
#     price_per_day: 30.0,
#     user: user1,
#     image_url: "https://images.unsplash.com/photo-1603278005344-c3ec48b61e73"
#   },
#   {
#     name: "Witch Outfit",
#     size: "38",
#     description: "Black velvet witch costume with pointy hat.",
#     price_per_day: 25.0,
#     user: user2,
#     image_url: "https://images.unsplash.com/photo-1585412727330-e9e6e0f69cd9"
#   },
#   {
#     name: "Pirate Costume",
#     size: "52",
#     description: "Swashbuckling pirate with hat, eyepatch, and coat.",
#     price_per_day: 28.0,
#     user: user3,
#     image_url: "https://images.unsplash.com/photo-1603371591806-2181728df58e"
#   },
#   {
#     name: "Princess Dress",
#     size: "36",
#     description: "Pink royal princess gown with glittering skirt.",
#     price_per_day: 32.0,
#     user: user4,
#     image_url: "https://images.unsplash.com/photo-1573509983142-37d953c82dd6"
#   },
#   {
#     name: "Samurai Warrior",
#     size: "50",
#     description: "Authentic-looking samurai costume with armor pieces.",
#     price_per_day: 40.0,
#     user: user5,
#     image_url: "https://images.unsplash.com/photo-1603553032172-4d21d5199562"
#   },
#   {
#     name: "Clown Suit",
#     size: "44",
#     description: "Colorful clown outfit with oversized shoes and nose.",
#     price_per_day: 22.0,
#     user: user6,
#     image_url: "https://images.unsplash.com/photo-1577992835207-f8d15d1d1a3d"
#   },
#   {
#     name: "Ghost Sheet",
#     size: "46",
#     description: "Simple ghost costume with eye holes – classic and spooky.",
#     price_per_day: 15.0,
#     user: user7,
#     image_url: "https://images.unsplash.com/photo-1599140786660-42e5c6fae324"
#   },
#   {
#     name: "Harry Potter Robe",
#     size: "40",
#     description: "Hogwarts uniform with Gryffindor badge and wand.",
#     price_per_day: 35.0,
#     user: user8,
#     image_url: "https://images.unsplash.com/photo-1602332918895-129ebc0f899d"
#   },
#   {
#     name: "Cowboy Outfit",
#     size: "54",
#     description: "Wild west cowboy with hat, vest, and boots.",
#     price_per_day: 27.0,
#     user: user9,
#     image_url: "https://images.unsplash.com/photo-1596462502278-27b4a1c9adcc"
#   },
#   {
#     name: "Cat Onesie",
#     size: "42",
#     description: "Comfy black cat onesie with ears and tail.",
#     price_per_day: 18.0,
#     user: user10,
#     image_url: "https://images.unsplash.com/photo-1549924231-f129b911e442"
#   }
# ]
