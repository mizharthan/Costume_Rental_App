class RentalsController < ApplicationController

  def index
    @rentals = current_user.rentals
  end

  def new
    @costume = Costume.find(params[:costume_id])
    @costume = Rental.new
  end

  def create
    @costume = Costume.find(params[:costume_id])
    @rental.costume = @costume
    @rental.status = "pending"
    @rental.price = costume.price_per_day * rental_duration_in_days

    if rental.save
      redirect_to rentals_path, "Rental request created!"
    else
      render :new
    end
  end

  def destroy
    @rental = Rental.find(params[:id])
    return unless @rental.user == current_user

      @rental.destroy
      redirect_to rentals_path, notice: "You have deleted the rental request."
end
