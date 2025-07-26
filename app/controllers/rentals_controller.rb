class RentalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rentals = current_user.rentals.includes(:costume)
  end

  def new
    @costume = Costume.find(params[:costume_id])
    @rental = Rental.new
  end

  def create
    @costume = Costume.find(params[:costume_id])
    @rental = Rental.new(rental_params)
    @rental.user = current_user
    @rental.costume = @costume
    @rental.status = "not_confirmed"
    @rental.price = @costume.price_per_day * rental_duration

    if @rental.save
      redirect_to rentals_path, notice: "Your rental request has been sent!"
    else
      render :new
    end
  end

  def destroy
    @rental = Rental.find(params[:id])
    if @rental.user == current_user
    @rental.destroy
    end
    redirect_to rentals_path, notice: "Your rental request was deleted."
  end

  private

  def rental_params
    params.require(:rental).permit(:start_date, :end_date)
  end

  def rental_duration
    start_param = params.dig(:rental, :start_date)
    end_param = params.dig(:rental, :end_date)

    return 0 if start_param.blank? || end_param.blank?

    start_date = start_param.to_date
    end_date = end_param.to_date

    (end_date - start_date).to_i + 1
  end
end
