require 'sidekiq/web'

Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web, at: 'sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  devise_for :users, controllers: {
    registrations: 'registrations',
    omniauth_callbacks: 'omniauth_callbacks'
  }
  resources :users, only: [:show]
  resources :identities, only: [:destroy]

  root to: 'home#index'
  match 'preview',          to: 'home#preview',         via: :get
  match 'about',            to: 'home#about',           via: :get
  match 'guidelines',       to: 'home#guidelines',      via: :get
  match 'contact',          to: 'home#contact',         via: :get
  match 'privacy',          to: 'home#privacy',         via: :get
  match 'terms',            to: 'home#terms',           via: :get
  get '/careers' => redirect('http://stories.sevenzo.org/careers')

  match 'states/search',    to: 'states#search',        via: :get
  match 'districts/search', to: 'districts#search',     via: :get
  match 'schools/search',   to: 'schools#search',       via: :get

  resources :inquiries,       only: [:create]

  resources :challenges, only: [:show, :index] do
    member do
      get :drawing
    end
    resources :experience_stages, only: [:show] do
      resources :themes, only: [:show] do
        resources :experiences do
          member do
            put :like, :unlike
          end
        end
      end
    end

    resources :idea_stages, only: [:show] do
      resources :problem_statements, only: [:show] do
        resources :ideas do
          member do
            put :like, :unlike
          end
        end
      end
    end

    resources :recipe_stages, only: [:show] do
      resources :cookbooks, only: [:show] do
        resources :recipes do
          member do
            put :like, :unlike, :try, :untry
          end
        end
      end
    end

    resources :solution_stages, only: [:show] do
      resources :solution_stories, only: [:show] do
        resources :solutions do
          member do
            put :like, :unlike
            get :file
          end
        end
      end
    end
  end

  resources :comments do
    member do
      put :like, :unlike
    end
  end

  resources :suggestions do
    member do
      put :like, :unlike
    end
  end
end
