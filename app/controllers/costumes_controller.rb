class CostumesController < ApplicationController
  before_action :authenticate_user!

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

  private

  def costume_params
    params.require(:costume).permit(:name, :size, :description, :price_per_day, :image, wearer_list: [])
  end
end
