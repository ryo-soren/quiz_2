Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "ideas#index"
  resource :session, only:[:new, :create, :destroy]
  resources :users, only:[:new, :create]

  resources :ideas do
    resources :reviews do
    end
    resources :likes, shallow: true, only: [:create, :destroy]

  end


end
