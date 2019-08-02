require 'geokit'

require "layers_of_london/booth/map_tool/engine"

module LayersOfLondon
  module Booth
    module MapTool
      class << self
        attr_accessor :configuration
      end

      def self.configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end

      class Configuration
        attr_accessor :square_size, :north_west_extent, :south_east_extent
      end
    end
  end
end
