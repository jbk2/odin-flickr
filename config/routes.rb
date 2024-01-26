Rails.application.routes.draw do
  get 'static_pages/home'
  post 'static_pages/flickr_users_images'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
end
