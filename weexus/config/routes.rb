Rails.application.routes.draw do
  resources :exclusions
  get 'home/index'
  get 'posts/review'
  get 'posts/rejected'
  get 'users/profile'

  resources :tags
  resources :posts do
    member do
      put "like", to: "posts#upvote"
      put "dislike", to: "posts#downvote"
    end
  end
  devise_for :users, :path_prefix => 'my'
  resources :users
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  get "/pages/:page" => "pages#howto"
end
