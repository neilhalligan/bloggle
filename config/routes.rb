Rails.application.routes.draw do
  get '/signup', to: "users#new"
  post '/signup', to: "users#create"
  root to: 'static_pages#home'

  get '/about', to: "static_pages#about"
  get '/help', to: "static_pages#help"
  # get '/user/:id', to: "users#show", as: "user"
  resources :users
  # get 'dashboard' => 'dashboards#dashboard', as: 'dashboard'
  # resources :static_pages, only: [:about, :help]



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
