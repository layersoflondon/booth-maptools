LayersOfLondon::Booth::MapTool::Engine.routes.draw do
  namespace :booth do
    get 'session', to: '/layers_of_london/booth/map_tool/application#session'
    resource :maptools, only: [:show] do

      resources :squares, only: [:index, :show] do
        collection do
          get :polygons
        end

        resources :polygons, except: [:new]
      end
    end
  end
end
