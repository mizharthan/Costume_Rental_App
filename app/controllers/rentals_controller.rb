class RentalsController < ApplicationController
  before_action :authenticate_user!

  def index
    # current user rental requests they made
    @rentals = current_user.rentals.includes(:costume)
  end

  def owner_requests
    # requests for the costumes the current user owns
    @rentals = Rental
    .joins(:costume)
    .where(costumes: { user_id: current_user.id })
    .order(created_at: :desc)
  end

  def new
    @costume = Costume.find(params[:costume_id])
    @rental = Rental.new
    @selected_wearer = params[:wearer]
  end

  def create
    @costume = Costume.find(params[:costume_id])
    @rental = Rental.new(rental_params)
    @rental.user = current_user
    @rental.costume = @costume
    @rental.status = "not_confirmed"
    @rental.price = @costume.price_per_day * rental_duration
    @rental.wearer_list.add(rental_params[:wearer])

    if @rental.save
      redirect_to rentals_path, notice: "Your rental request has been sent!"
    else
      render :new
    end
  end

  def update
    @rental = Rental.find(params[:id])
    if @rental.update(rental_params)
      redirect_to rental_requests_path, notice: "Rental request status updated!"
    else
      redirect_to rental_requests_path, alert: "Could not update status."
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
    params.require(:rental).permit(:start_date, :end_date, :wearer, :status)
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
