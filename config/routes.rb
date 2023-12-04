Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :documents, only: [:new, :create, :index] do
        collection do
          get 'list', to: 'documents#index'
          get 'template', to: 'documents#template'
          delete 'exclude', to: 'documents#destroy'
        end
        
        member do
          get 'download', to: 'documents#download'
        end
      end
    end
  end

  root 'api/v1/documents#index'
end
