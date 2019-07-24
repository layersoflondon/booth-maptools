require_dependency "layers_of_london/booth/map_tool/application_controller"

module LayersOfLondon::Booth::MapTool
  class PolygonsController < ApplicationController
    def index
      features = LayersOfLondon::Booth::MapTool::Polygon.all.collect(&:to_json)

      feature = {
        type: "FeatureCollection",
        features: features
      }
      render json: feature
    end

    def create
      square = LayersOfLondon::Booth::MapTool::Square.find(params[:square_id]) || LayersOfLondon::Booth::MapTool::Square.new
      square.polygons.create(params)
    end

    def update
    end

    def destroy
    end
  end
end
