Rails.application.routes.draw do
  root to: 'loan_rates#map'

  get 'map', to: 'loan_rates#map', as: :map
  resources :loan_rates
end
