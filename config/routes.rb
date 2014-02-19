Rails.application.routes.draw do
  root 'main#index'
  get 'search', to: 'main#search'
end
