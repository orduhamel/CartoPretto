Rails.application.routes.draw do
  root to: 'projects#map'
  get 'map', to: 'projects#map', as: :map
end
