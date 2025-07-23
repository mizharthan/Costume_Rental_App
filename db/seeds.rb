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

costumes = [
  {
    name: "Vampire Cape",
    size: "48",
    description: "Classic Dracula-style vampire costume with red-lined cape.",
    price_per_day: 30.0,
    user: user1,
    image_url: "https://images.unsplash.com/photo-1603278005344-c3ec48b61e73"
  },
  {
    name: "Witch Outfit",
    size: "38",
    description: "Black velvet witch costume with pointy hat.",
    price_per_day: 25.0,
    user: user2,
    image_url: "https://images.unsplash.com/photo-1585412727330-e9e6e0f69cd9"
  },
  {
    name: "Pirate Costume",
    size: "52",
    description: "Swashbuckling pirate with hat, eyepatch, and coat.",
    price_per_day: 28.0,
    user: user3,
    image_url: "https://images.unsplash.com/photo-1603371591806-2181728df58e"
  },
  {
    name: "Princess Dress",
    size: "36",
    description: "Pink royal princess gown with glittering skirt.",
    price_per_day: 32.0,
    user: user4,
    image_url: "https://images.unsplash.com/photo-1573509983142-37d953c82dd6"
  },
  {
    name: "Samurai Warrior",
    size: "50",
    description: "Authentic-looking samurai costume with armor pieces.",
    price_per_day: 40.0,
    user: user5,
    image_url: "https://images.unsplash.com/photo-1603553032172-4d21d5199562"
  },
  {
    name: "Clown Suit",
    size: "44",
    description: "Colorful clown outfit with oversized shoes and nose.",
    price_per_day: 22.0,
    user: user6,
    image_url: "https://images.unsplash.com/photo-1577992835207-f8d15d1d1a3d"
  },
  {
    name: "Ghost Sheet",
    size: "46",
    description: "Simple ghost costume with eye holes – classic and spooky.",
    price_per_day: 15.0,
    user: user7,
    image_url: "https://images.unsplash.com/photo-1599140786660-42e5c6fae324"
  },
  {
    name: "Harry Potter Robe",
    size: "40",
    description: "Hogwarts uniform with Gryffindor badge and wand.",
    price_per_day: 35.0,
    user: user8,
    image_url: "https://images.unsplash.com/photo-1602332918895-129ebc0f899d"
  },
  {
    name: "Cowboy Outfit",
    size: "54",
    description: "Wild west cowboy with hat, vest, and boots.",
    price_per_day: 27.0,
    user: user9,
    image_url: "https://images.unsplash.com/photo-1596462502278-27b4a1c9adcc"
  },
  {
    name: "Cat Onesie",
    size: "42",
    description: "Comfy black cat onesie with ears and tail.",
    price_per_day: 18.0,
    user: user10,
    image_url: "https://images.unsplash.com/photo-1549924231-f129b911e442"
  }
]
