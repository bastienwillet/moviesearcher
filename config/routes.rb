Rails.application.routes.draw do
  root to: "movies#index"
  post "/search", to: "movies#search"
end
