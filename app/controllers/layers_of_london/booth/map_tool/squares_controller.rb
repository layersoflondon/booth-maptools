require_dependency "layers_of_london/booth/map_tool/application_controller"

module LayersOfLondon::Booth::MapTool
  class SquaresController < ApplicationController
    skip_after_action :verify_authorized rescue nil

    def index
      squares = LayersOfLondon::Booth::MapTool::Square.all
      render json: squares
    end

    def polygons
      features = LayersOfLondon::Booth::MapTool::Polygon.all.collect do |polygon|
        user_can_edit = LayersOfLondon::Booth::MapTool::PolygonPolicy.new(current_user, polygon).update?
        polygon.to_json(user_can_edit: user_can_edit)
      end

      feature_collection = {
        type: "FeatureCollection",
        features: features
      }

      render json: feature_collection
    end

    def show
      square = LayersOfLondon::Booth::MapTool::Square.find(params[:id]) rescue LayersOfLondon::Booth::MapTool::Square.create
      render json: square
    end
  end
end
