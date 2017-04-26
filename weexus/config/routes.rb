Rails.application.routes.draw do
  resources :exclusions
  get 'home/index'

  resources :tags
  resources :posts
  devise_for :users
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
