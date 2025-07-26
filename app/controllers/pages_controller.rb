class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @costumes = Costume.all
    @popular_costumes = Costume.where(category: "Popular").limit(10)
    @superhero_costumes = Costume.where(category: "Superhero").limit(10)
    @anime_costumes = Costume.where(category: "Anime").limit(10)
  end
end
