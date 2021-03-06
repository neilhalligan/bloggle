Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/about', to: "static_pages#about"
  get '/help', to: "static_pages#help"
  get '/signup', to: "users#new"
  post '/signup', to: "users#create"
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:edit, :update, :new, :create]
  resources :posts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]




  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
