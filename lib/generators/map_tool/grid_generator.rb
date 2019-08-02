module MapTool
  class GridGenerator < ::Rails::Generators::Base
    desc "Generate grid squares in a pattern from the configured north_west_extent to the south_east_extent, of size square_size"
    def create_squares
      config = LayersOfLondon::Booth::MapTool.configuration
      north_west = Geokit::LatLng.new(*config.north_west_extent)
      south_east = Geokit::LatLng.new(*config.south_east_extent)
      north_east = Geokit::LatLng.new(north_west.lat, south_east.lng)
      south_west = Geokit::LatLng.new(south_east.lat, north_west.lng)

      squares_x = (north_west.distance_to(north_east, units: :meters) / config.square_size).ceil
      squares_y = (north_west.distance_to(south_west, units: :meters) / config.square_size).ceil

      squares_y.times do |row|
        # get the lat/lng for the northwest corner of this row by heading south (180º) from the northwest point by the number of rows * the size of the squares
        row_north_west = north_west.endpoint(180,(row +1 )*config.square_size, units: :meters)
        puts "Creating row #{row}"
        squares_x.times do |col|
          puts "\tCreating column #{col}"
          # get the square's northwest corner by moving east (90º) by the number of columns from the row's northwest
          square_north_west = row_north_west.endpoint(90,col*config.square_size, units: :meters)
          LayersOfLondon::Booth::MapTool::Square.create(north_west_lat: square_north_west.lat, north_west_lng: square_north_west.lng)
        end
      end

    end
  end
end
