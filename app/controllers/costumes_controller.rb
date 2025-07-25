class CostumesController < ApplicationController
  before_action :authenticate_user!

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
    params.require(:costume).permit(:size, :name, :description, :price_per_day, :image)
  end
end
