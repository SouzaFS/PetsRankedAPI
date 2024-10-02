Rails.application.routes.draw do
  resources :pets
  resources :users
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  root to: redirect('/api-docs')

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/logout', to: 'sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
