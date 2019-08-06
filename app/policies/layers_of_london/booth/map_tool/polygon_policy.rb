module LayersOfLondon::Booth::MapTool
  class PolygonPolicy < ApplicationPolicy
    def show?
      true
    end

    def update?
      record.user.id === user.try(:id) && record.square.editable?
    end

    def destroy?
      update?
    end

    def create?
      user.present?
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
