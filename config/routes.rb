Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "chats#index"

  resources :chats, only: [:index, :show, :new, :create]
  resources :messages, only: [:create]
end
