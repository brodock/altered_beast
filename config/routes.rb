AlteredBeast::Application.routes.draw do
  devise_for :users,  :controllers => { :registrations => 'registrations', :sessions => 'sessions' }
  resources :sites, :moderatorships, :monitorship

  resources :forums do
    resources :topics do
      resources :posts
      resource :monitorship
    end
    resources :posts
  end

  resources :posts do
    get :search, :on => :collection
  end
  resources :users do
    member do
      put :suspend, :make_admin, :unsuspend
      get :settings
      delete :purge
    end
    resources :posts, :only => [:index] do
#      get :monitored, :on => :collection, :shallow => true
    end
  end
  match '/users/:user_id/monitored(.:format)' => 'posts#monitored', :as => 'monitored_posts'
  match '/settings' => 'users#settings', :as => 'settings'

  root :to => 'forums#index'
end
