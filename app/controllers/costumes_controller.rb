class CostumesController < ApplicationController
  before_action :authenticate_user!

  def index
    @costumes = Costume.all

    if params[:query].present?
      @costumes = Costume.where("name ILIKE ?", "%#{params[:query].downcase}%")
    else
      @costumes = Costume.all
    end
  end

  def show
    @costume = Costume.find(params[:id])
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

  private

  def costume_params
    params.require(:costume).permit(:name, :size, :description, :price_per_day, :image, wearer_list: [])
  end
end
