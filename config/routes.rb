Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/about', to: "static_pages#about"
  get '/help', to: "static_pages#help"
  get '/signup', to: "users#new"
  post '/signup', to: "users#create"
  get '/login', to: 'sessions#new'
  post '/login', to: 'session#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users





  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
