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

    def update
      square = LayersOfLondon::Booth::MapTool::Square.find(params[:id])
      proposed_state = params[:state]

      if square.send("may_mark_as_#{proposed_state}?")
        square.send("mark_as_#{proposed_state}!")

        render json: square.to_json
      else
        render json: {}, status: :unprocessable_entity
      end
    end

    def show
      square = LayersOfLondon::Booth::MapTool::Square.find(params[:id]) rescue LayersOfLondon::Booth::MapTool::Square.create
      render json: square.to_json
    end
  end
end
