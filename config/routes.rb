Rails.application.routes.draw do
  root to: 'projects#map'

  resources :projects
  get 'map', to: 'projects#map', as: :map
end
