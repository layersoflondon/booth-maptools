LayersOfLondon::Booth::MapTool::Engine.routes.draw do
  namespace :booth do
    resource :maptools, only: [:show] do
      resources :squares, except: [:new, :destroy]
    end
  end
end
