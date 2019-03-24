Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/search',  to: 'search#search'
  get    '/recommend', to: 'recommend#index'

  resources :users do
    member do
      get :following, :followers, :media, :likes
    end
  end

  resources :microposts,          only: [:create, :destroy, :show] do    
    resources :comments,          only: [:create, :destroy]
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]

  namespace :api do

    resources :microposts, only: [] do
      resource :likes, only: [:create, :destroy], module: :microposts
    end
    resources :comments, only: [] do
      resource :likes, only: [:create, :destroy], module: :comments
    end
  end
end
