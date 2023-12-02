Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :documents, only: [] do
        collection do
          get 'list', to: 'documents#index'
          get 'template', to: 'documents#template'
          post 'create', to: 'documents#create'
        end
        
        member do
          get 'download', to: 'documents#download'
        end
      end
    end
  end
end
