Rails.application.routes.draw do
  root 'needs#index'

  resources :contacts, only: [:index, :show, :edit, :update, :new, :create] do
    resources :needs, only: [:new, :create]
    resources :assessments, only: [:new, :create]
    # collection do
    #   get 'call-list'
    # end
    get 'triage', to: 'triage#edit', as: 'edit_triage'
    put 'triage', to: 'triage#update', as: 'triage'
  end
  # get '/contacts/:id/needs', to: 'contacts#needs'

  resources :needs, only: [:index, :show, :edit, :update, :destroy] do
    resources :notes
  end

  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  post 'role', to: 'users#set_role', as: 'set_role'
  passwordless_for :users, at: '/', as: :auth

  patch '/assign_multiple' => 'needs#assign_multiple'

  post '/needs/request_destroy_need' => 'needs#request_destroy_need'
  post '/needs/request_destroy_note' => 'needs#request_destroy_note'
end
