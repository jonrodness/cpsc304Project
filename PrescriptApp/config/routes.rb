Rails.application.routes.draw do
  devise_for :views
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'site#homepage'

  resources :drugs

 # get 'tables/index' => 'tables#index'
  resources :tables
  get '/tables' => 'tables#index'
  ##
  # post 'tables' => 'tables#create'
  # get 'tables/new' => 'tables#new'
  # get    'tables/:id/edit' => 'tables#edit'
  # get    'tables/:id' =>  'tables#show'
  # patch  'tables/:id' => 'tables#update'
  # put    'tables/:id' => 'tables#update'
  # delete 'tables/:id' =>  'tables#destroy'

  #get '/tables/index' => 'tables#index'


  get 'qPh1' => 'tables#qPh1'
  post '/tables/qPh2' => 'tables#qPh2', :as => 'qPh2'
  post '/tables/qPh3' => 'tables#qPh3', :as => 'qPh3'
  get 'qPh4' => 'tables#qPh4'
  post '/tables/qPh5' => 'tables#qPh5', :as => 'qPh5'

  #get '/qPa1' => 'tables#index'
  #match 'qPa1' => 'tables#qPa1', via: [:patch]
   #post '/qPa1p' => 'tables#qPa1p'
  #get 'qPa1' => 'tables#qPa1'

  post '/tables/qPa1' => 'tables#qPa1', :as => 'qPa1'
  get 'qPa2' => 'tables#qPa2'
  get 'qPa3' => 'tables#qPa3'
  post '/tables/qPa4' => 'tables#qPa4', :as => 'qPa4'
  post '/tables/qPa5' => 'tables#qPa5', :as => 'qPa5'
  get 'qPa6a' => 'tables#qPa6a'
  post '/tables/qPa6b' => 'tables#qPa6b', :as => 'qPa6b'
  post '/tables/qPa6c' => 'tables#qPa6c', :as => 'qPa6c'
  post '/tables/qPa7' => 'tables#qPa7', :as => 'qPa7'
  post '/tables/qPa8' => 'tables#qPa8', :as => 'qPa8'
  get 'qPa9' => 'tables#qPa9'
  get 'qPa10' => 'tables#qPa10'
  get 'qPa11' => 'tables#qPa11'

  get 'qD1' => 'tables#qD1'
  get 'qD2' => 'tables#qD2'
  get 'qD3' => 'tables#qD3'
  get 'qD4' => 'tables#qD4'
  get 'qD5' => 'tables#qD5'
  get 'qD6' => 'tables#qD6'
  get 'qD7' => 'tables#qD7'
  get 'qD8' => 'tables#qD8'
  get 'qD9' => 'tables#qD9'
  get 'qD10' => 'tables#qD10'
  get 'qD11' => 'tables#qD11'
  get 'qD12' => 'tables#qD12'
  get 'qD13' => 'tables#qD13'
  get 'qD14' => 'tables#qD14'
  get 'qD15' => 'tables#qD15'
  get 'qD16' => 'tables#qD16'



  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
