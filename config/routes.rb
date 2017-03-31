Rails.application.routes.draw do
  root to: 'static_pages#home'

  get 'static_pages/about'
  get 'static_pages/help'# => "static_pages#help"
  # get 'dashboard' => 'dashboards#dashboard', as: 'dashboard'
  # resources :static_pages, only: [:about, :help]



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
