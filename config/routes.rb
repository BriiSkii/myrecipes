Rails.application.routes.draw do
  get 'pages/home', to: 'pages#home'
  root 'pages#home'

  resources :recipes
  get '/signup', to: 'chefs#new'
  resources :chefs, except:[:new]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'session#destroy'
end
