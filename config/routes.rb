Rails.application.routes.draw do
  namespace :api, format: :json do
    post :encode, to: 'shortener_urls#encode'
    post :decode, to: 'shortener_urls#decode'
  end
end
