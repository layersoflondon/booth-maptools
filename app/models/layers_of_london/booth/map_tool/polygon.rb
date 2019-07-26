module LayersOfLondon::Booth::MapTool
  class Polygon < ApplicationRecord
    belongs_to :square, optional: true

    serialize :feature, JSON

    def to_json
      feature.inject({}) do |hash, (k,v)|
        v.merge!({'id' => id}) if k === 'properties'

        hash[k] = v
        hash
      end
    end
  end
end
