require_dependency "layers_of_london/booth/map_tool/application_controller"

module LayersOfLondon::Booth::MapTool
  class SquaresController < ApplicationController
    def index
      squares = LayersOfLondon::Booth::MapTool::Square.all
      render json: squares
    end

    def polygons
      squares = LayersOfLondon::Booth::MapTool::Square.includes(:polygons)
      feature_collection = {
        type: "FeatureCollection",
        features: squares.collect(&:polygons).flatten.collect(&:to_json)
      }

      render json: feature_collection
    end

    def show
      square = LayersOfLondon::Booth::MapTool::Square.find(params[:id]) rescue LayersOfLondon::Booth::MapTool::Square.create
      render json: square
    end
  end
end
