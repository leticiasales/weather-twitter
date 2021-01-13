Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :api do
    resources :cities, only: :index
    post :forecast, to: 'cities#forecast'
  end
end
