class RentalsController < ApplicationController
  before_action :authenticate_user!

  def rental_request_list
    @rentals = current_user.rentals.includes(:costume)
  end

  def new
    @costume = Costume.find(params[:costume_id])
    @rental = Rental.new
  end

  def create
    @costume = Costume.find(params[:costume_id])
    @rental = current_user.rentals.build(rental_params)
    @rental.costume = @costume
    @rental.status = "not_confirmed"
    @rental.price = @costume.price_per_day * rental_duration_in_days

    if @rental.save
      redirect_to rentals_path, notice: "Your rental request has been sent!"
    else
      render :new
    end
  end

  def update
    @rental = Rental.find(params[:id])
    if @rental.costume.user == current_user
      if @rental.update(status: params[:status])
        redirect_to rentals_path, notice: "Rental request has been updated"
      else
        redirect_to rentals_path, alert: "Failed to update the rental status"
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    @rental = Rental.find(params[:id])
    return unless @rental.user == current_user

    @rental.destroy
    redirect_to rentals_path, notice: "Your rental request was deleted."
  end

  private

  def rental_params
    params.require(:rental).permit(:start_date, :end_date)
  end

  def rental_duration_in_days
    (Date.parse(params[:rental][:end_date]) - Date.parse(params[:rental][:start_date])).to_i + 1
  end
end
