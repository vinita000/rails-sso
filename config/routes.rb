Rails.application.routes.draw do
  root 'homes#index'
  scope :auth do
    get 'failure' => 'auth0#failure'
    
    # Auth0 routes    
    scope :auth0 do
      get 'callback' => 'auth0#callback'
      get 'logout' => 'auth0#logout'
    end
  end
  get 'profile', to: 'users#profile'
end
  
