Rails.application.routes.draw do
  devise_for :views
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'site#homepage'

  resources :drugs

  get 'qPh1' => 'drugs#qPh1'
  get 'qPh2' => 'drugs#qPh2'
  get 'qPh3' => 'drugs#qPh3'
  get 'qPh4' => 'drugs#qPh4'
  get 'qPh5' => 'drugs#qPh5'

  get 'qPa1' => 'drugs#qPa1'
  get 'qPa2' => 'drugs#qPa2'
  get 'qPa3' => 'drugs#qPa3'
  get 'qPa4' => 'drugs#qPa4'
  get 'qPa5' => 'drugs#qPa5'
  get 'qPa6' => 'drugs#qPa6'
  get 'qPa7' => 'drugs#qPa7'
  get 'qPa8' => 'drugs#qPa8'
  get 'qPa9' => 'drugs#qPa9'
  get 'qPa10' => 'drugs#qPa10'
  get 'qPa11' => 'drugs#qPa11'

  get 'qD1' => 'drugs#qD1'
  get 'qD2' => 'drugs#qD2'
  get 'qD3' => 'drugs#qD3'
  get 'qD4' => 'drugs#qD4'
  get 'qD5' => 'drugs#qD5'
  get 'qD6' => 'drugs#qD6'
  get 'qD7' => 'drugs#qD7'
  get 'qD8' => 'drugs#qD8'
  get 'qD9' => 'drugs#qD9'
  get 'qD10' => 'drugs#qD10'
  get 'qD11' => 'drugs#qD11'
  get 'qD12' => 'drugs#qD12'
  get 'qD13' => 'drugs#qD13'
  get 'qD14' => 'drugs#qD14'
  get 'qD15' => 'drugs#qD15'
  get 'qD16' => 'drugs#qD16'



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
