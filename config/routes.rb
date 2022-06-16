Rails.application.routes.draw do
  root to: 'projects#map'
  get 'map', to: 'projects#map', as: :map
  get 'map_results', to: 'projects#map_results', as: :map_results
end
