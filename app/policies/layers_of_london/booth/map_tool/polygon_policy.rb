module LayersOfLondon::Booth::MapTool
  class PolygonPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
