module MapTool
  class GridGenerator < ::Rails::Generators::Base
    desc "Generate grid squares in a pattern from the configured north_west_extent to the south_east_extent, of size square_size"
    def create_squares
      config = LayersOfLondon::Booth::MapTool.configuration

      squares_y = config.squares_y
      squares_x = config.squares_x
      north_west = config.north_west
      row_north_west = north_west

      squares_y.times do |row|
        puts "Creating row #{row}"
          square_north_west = row_north_west
        squares_x.times do |col|
          puts "\tCreating column #{col}"
          LayersOfLondon::Booth::MapTool::Square.create(north_west_lat: square_north_west.lat, north_west_lng: square_north_west.lng)
          # get the next square's northwest corner by moving east (90º) by the number of columns from the row's northwest
          square_north_west = square_north_west.endpoint(90, config.square_size, units: :meters)
        end
        # increment row_north_west by square_size, southwards, ready for the next iteration
        row_north_west = row_north_west.endpoint(180, config.square_size, units: :meters)
      end

    end
  end
end
