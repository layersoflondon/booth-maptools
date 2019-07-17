module LayersOfLondon
  module Booth
    module MapTool
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
      end
    end
  end
end
