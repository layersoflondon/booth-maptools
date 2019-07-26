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
      square = LayersOfLondon::Booth::MapTool::Square.find(params[:square_id]) rescue LayersOfLondon::Booth::MapTool::Square.create
      poly = square.polygons.create(feature: polygon_params)

      render json: poly.to_json
    end

    def update
      poly = LayersOfLondon::Booth::MapTool::Polygon.find(params[:id])

      return render json: {data: "Error"}, status: :unprocessable_entity unless poly

      poly.assign_attributes(feature: polygon_params)

      if poly.save
        render json: poly.to_json
      else
        render json: {data: "Error"}, status: :unprocessable_entity
      end
    end

    def destroy
      poly = LayersOfLondon::Booth::MapTool::Polygon.find(params[:id])

      return render json: {data: "Error"}, status: :unprocessable_entity unless poly

      if poly.destroy
        render json: :ok, status: :ok
      else
        render json: :error, status: :unprocessable_entity
      end
    end

    private
    def polygon_params
      params.require(:feature)
    end
  end
end
