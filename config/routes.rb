LayersOfLondon::Booth::MapTool::Engine.routes.draw do
  namespace :booth do
    resource :maptools, only: [:show] do
      resources :squares, only: [:index, :show] do
        collection do
          get :polygons
        end

        resources :polygons, except: [:new, :show]
      end
    end
  end
end
