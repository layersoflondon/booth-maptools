module LayersOfLondon::Booth::MapTool
  class Square < ApplicationRecord
    has_many :polygons
  end
end
