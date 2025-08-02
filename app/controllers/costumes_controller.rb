class CostumesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @costumes = Costume.all

    # Search by name
    if params[:query].present?
      @costumes = Costume.where("name ILIKE ?", "%#{params[:query].downcase}%")
    end

    # Filter by wearer
    if params[:wearer].present?
      @costumes = Costume.tagged_with(params[:wearer], on: :wearers)
    end
  end

  def show
    @costume = Costume.find(params[:id])

    @similar_costumes = Costume
      .where(category: @costume.category)
      .where.not(id: @costume.id)
      .order("RANDOM()")
      .limit(3)

    if @similar_costumes.empty?
      @similar_costumes = Costume.where.not(id: @costume.id).order("RANDOM()").limit(3)
    end
  end

  def my_listings
    @costumes = current_user.costumes
  end

  def new
    @costume = Costume.new
  end

  def create
    @costume = Costume.new(costume_params)
    @costume.user = current_user

    if @costume.save
      redirect_to @costume, notice: "Costume was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @costume = Costume.find(params[:id])
    @costume.destroy
    redirect_to root_path, notice: "Costume was successfully deleted."
  end

  def edit
    @costume = Costume.find(params[:id])
  end

  def update
    @costume = Costume.find(params[:id])
    if @costume.update(costume_params)
      redirect_to @costume, notice: "Costume updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def costume_params
    params.require(:costume).permit(
      :name, :size, :description, :price_per_day, :photo, :category,
      photos: [], wearer_list: []
    )
  end

  def authorize_user!
    @costume = Costume.find(params[:id])
    unless @costume.user == current_user
      redirect_to root_path, alert: "You are not authorized to modify this costume."
    end
  end
end
