Rails.application.routes.draw do
  root to: "welcome#index"
  get 'get_reviews',:to => 'pages#get_reviews', :as => 'get_reviews'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
