module LayersOfLondon
  module Booth
    module MapTool
      class Engine < ::Rails::Engine
        isolate_namespace LayersOfLondon::Booth::MapTool

        config.before_initialize do
          LayersOfLondon::Booth::MapTool.configure {} if LayersOfLondon::Booth::MapTool.configuration.nil?
        end

        initializer "configure_booth_maptool" do
          LayersOfLondon::Booth::MapTool.configure do |config|
            config.square_size = LayersOfLondon::Booth::MapTool.configuration.square_size
          end
        end
      end
    end
  end
end
