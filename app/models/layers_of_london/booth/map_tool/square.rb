module LayersOfLondon::Booth::MapTool
  class Square < ApplicationRecord
    has_many :polygons

    def to_json
      {id: id}
    end
  end
end
