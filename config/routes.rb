Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/providers/', to: 'providers#index'
  get '/providers/:provider_id', to: 'providers#show', as: :provider_show
  get '/providers/:provider_id/individuals/:individual_id', to: 'providers#individual', as: :individual_show
end
