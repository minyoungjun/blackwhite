Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#sorry'
  get 'instant' => 'main#index'
  get 'main/index' => 'main#index'
  get 'main/room/:id' => "main#room"
  get 'main/new_room'
  post 'main/game_start'
  post 'main/turn_action'
  post 'senders/json_action'
  post 'senders/game_start'
  post 'senders/player_action.json' => 'senders#player_action'
  post 'senders/enemy_action.json' => 'senders#enemy_action'
  post 'senders/game_start.json' => 'senders#game_start'
  post 'senders/change_title.json' => "senders#change_title"
  post 'senders/send_chat.json' => "senders#send_chat"
  post 'senders/block_chat.json' => "senders#block_chat"
  post 'main/feedback'
  get 'main/read'

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
