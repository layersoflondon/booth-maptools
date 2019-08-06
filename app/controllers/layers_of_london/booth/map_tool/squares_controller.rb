require_dependency "layers_of_london/booth/map_tool/application_controller"

module LayersOfLondon::Booth::MapTool
  class SquaresController < ApplicationController
    skip_after_action :verify_authorized rescue nil

    def index
      squares = LayersOfLondon::Booth::MapTool::Square.where.not(aasm_state: :not_started)
      render json: {
        type: "FeatureCollection",
        features: squares.collect(&:to_geojson)
      }
    end

    def grid
      render json: {
        type: "FeatureCollection",
        features: Square.grid_coordinates.collect do |coords|
          {
            type: "Feature",
            geometry: {
              type: "LineString",
              coordinates: coords
            },
            properties: {}
          }
        end
      }
    end

    def coordinates
      squares = LayersOfLondon::Booth::MapTool::Square.all
      square_data = squares.collect do |square|
        {
          id: square.id,
          nw: square.north_west.to_a,
          se: square.south_east.to_a
        }
      end

      render json: square_data

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
      render json: square.to_json(padding: 20)
    end
  end
end
