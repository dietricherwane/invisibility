# -*- encoding : utf-8 -*-
Invisibility::Application.routes.draw do
	#match '/users/index' => 'users#index'
	
  root :to => "sessions#new"
  resources :administrators
  resources :users
  resource :session
  resources :parameters
  match '/login' => "sessions#new", :as => "login"
	match '/logout' => "sessions#destroy", :as => "logout"
  match '/statistiques' => 'users#stats', :as => :stats
  match '/dashboard' => 'users#stats', :as => :dashboard
  match '/reports' => "users#reports", :as => :reports
  match '/nombre_de_sms_par_utilisateur' => 'users#nombre_de_sms_par_utilisateur', :as => :nombre_de_sms_par_utilisateur
  match '/sms_par_utilisateur_mail' => 'users#nombre_de_sms_par_utilisateur_mail', :as => :sms_par_utilisateur_mail
  match '/nombre_de_sms_par_couple' => 'users#nombre_de_sms_par_couple', :as => :nombre_de_sms_par_couple
  match '/sms_par_couple_mail' => 'users#nombre_de_sms_par_couple_mail', :as => :sms_par_couple_mail
  match '/send_email' => "users#send_email", :as => :send_email
  match '/write_to_disk' => 'users#write_to_disk', :as => :write_to_disk

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
