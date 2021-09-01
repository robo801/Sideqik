Rails.application.routes.draw do
  post 'create', to: 'endpoints#create'
  post 'login', to: 'endpoints#login'
  post 'create_short_url', to: 'endpoints#create_short_url'
  get 'url', to: 'endpoints#get_url'
end
