require_dependency "layers_of_london/booth/map_tool/application_controller"

module LayersOfLondon::Booth::MapTool
  class SquaresController < ApplicationController
    def index
      squares = LayersOfLondon::Booth::MapTool::Square.all
      render json: squares
    end

    def show
      square = LayersOfLondon::Booth::MapTool::Square.find(params[:id]) || LayersOfLondon::Booth::MapTool::Square.new
      render json: square
    end
  end
end
