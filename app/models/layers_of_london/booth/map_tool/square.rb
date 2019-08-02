module LayersOfLondon::Booth::MapTool
  class Square < ApplicationRecord
    has_many :polygons, dependent: :destroy



    validates_presence_of :north_west_lat, :north_west_lng, :south_east_lat, :south_east_lng, :square_size

    before_validation on: :create do
      self.north_west_lat = self.north_west_lat.round(5)
      self.north_west_lng = self.north_west_lng.round(5)
      self.square_size = LayersOfLondon::Booth::MapTool.configuration.square_size
      self.south_east_lat = south_east.lat
      self.south_east_lng = south_east.lng
      self.geojson = self.to_geojson
    end

    serialize :geojson, JSON

    include AASM
    aasm do
      state :not_started, initial: true
      state :in_progress
      state :done
      state :flagged

      event :mark_as_in_progress do
        transitions from: :not_started, to: [:in_progress]
      end

      event :mark_as_done do
        transitions from: [:in_progress, :flagged], to: :done
      end

      event :mark_as_flagged do
        transitions from: [:in_progress, :done], to: :flagged
      end

      event :mark_as_back_in_progress do
        transitions from: [:flagged, :done], to: :in_progress
      end
    end

    def to_json
      {id: id, state: {label: aasm_state, description: aasm_state.humanize}}
    end

    def to_geojson
      {
        type: "Feature",
        geometry: {
          type: "Polygon",
          coordinates: [
            [
              north_west.to_a.collect {|coord| coord.round(5)}.reverse,
              south_west.to_a.collect {|coord| coord.round(5)}.reverse,
              south_east.to_a.collect {|coord| coord.round(5)}.reverse,
              north_east.to_a.collect {|coord| coord.round(5)}.reverse,
              north_west.to_a.collect {|coord| coord.round(5)}.reverse
            ]
          ]
        },
        properties: {
          id: id,
          state: aasm_state,
          centroid: centroid.to_a.collect {|coord| coord.round(5)}
        }
      }
    end

    def north_west
      Geokit::LatLng.new(north_west_lat, north_west_lng)
    end

    def north_east
      north_west.endpoint(90, square_size, units: :meters)
    end

    def south_west
      north_west.endpoint(180, square_size, units: :meters)
    end

    def south_east
      south_west.endpoint(90, square_size, units: :meters)
    end

    def centroid
      north_west.midpoint_to(south_east)
    end
    
  end
end
