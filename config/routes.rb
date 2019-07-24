LayersOfLondon::Booth::MapTool::Engine.routes.draw do
  namespace :booth do
    resource :maptools, only: [:show] do
      resources :squares, only: [:show] do
        resources :polygons, except: [:new, :show]
      end
    end
  end
end
