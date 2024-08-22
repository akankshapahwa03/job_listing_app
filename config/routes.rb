Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  
  root 'pages#home'
  get '/dashboard', to: "dashboard#index"
  devise_for :users, controllers: { invitations: 'users/invitations', sessions: 'users/sessions' }

  devise_scope :user do
    get 'users/verify_otp', to: 'users/sessions#verify_otp'
    post 'users/verify_otp', to: 'users/sessions#verify_otp'
    post 'users/resend_otp', to: 'users/sessions#resend_otp'
  end

  resources :notifications do
    member do
      post :mark_as_read
    end
  end
  

  resources :users, only: %i[show edit update destroy]
  resources :jobs do
    member do
      post :share
    end
    collection do
      get :draft
    end
  end
end
