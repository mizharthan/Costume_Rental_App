Rails.application.routes.draw do
  get 'costumes/show' # Temporary hardcoded route for testing costume show page without an ID
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "pages/home", to: "pages#home"
  get "search", to: "pages#search"

  resources :costumes do
    resources :rentals, only: [:new, :create]
  end

  resources :rentals, only: [:index, :update, :destroy]
end
