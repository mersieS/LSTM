# config/routes.rb
Rails.application.routes.draw do
  resources :traffic_data, only: [:index, :show]
  post 'data/train_model', to: 'data#train_model', as: 'train_model'
  post 'data/predict_data', to: 'data#predict_data', as: 'predict_data'
end
