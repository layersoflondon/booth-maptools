module LayersOfLondon::Booth::MapTool
  class Polygon < ApplicationRecord
    belongs_to :square, optional: true
    belongs_to :user

    serialize :feature, JSON

    def to_json(user_can_edit: false)
      feature.inject({}) do |hash, (k,v)|
        v.merge!({'id' => id, 'userCanEdit': user_can_edit}) if k === 'properties'

        hash[k] = v
        hash
      end
    end
  end
end
