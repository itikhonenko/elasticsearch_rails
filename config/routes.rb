Rails.application.routes.draw do
  namespace :api do
    get :search, controller: :search
  end
end
