module LayersOfLondon::Booth::MapTool
  class Polygon < ApplicationRecord
    belongs_to :square, optional: true

    serialize :feature, JSON

    def to_json
      feature.try(:merge, {id: id})
    end
  end
end
