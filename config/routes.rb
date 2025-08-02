Rails.application.routes.draw do
  # get 'costumes/show' # Temporary hardcoded route for testing costume show page without an ID
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "rental_requests", to: "rentals#owner_requests", as: :rental_requests
  # Defines the root path route ("/")
  # root "posts#index"
  get "pages/home", to: "pages#home"
  # i don't think we need the line above since we already have line 4 but can optimize later.
  get "search", to: "pages#search"
  get "search", to: "costumes#index"

  get "my_costumes", to: "costumes#my_listings", as: "my_costumes"

  resources :costumes do
    resources :rentals, only: [:new, :create]
  end

  resources :rentals, only: [:index, :update, :destroy]
end
