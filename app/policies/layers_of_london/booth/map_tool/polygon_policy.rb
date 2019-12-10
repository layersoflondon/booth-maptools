module LayersOfLondon::Booth::MapTool
  class PolygonPolicy < ApplicationPolicy
    def show?
      true
    end

    def update?
      user.present? && record.user.try(:id) === user.try(:id) && record.square.editable?
    end

    def destroy?
      update?
    end

    def create?
      user.present?
    end

    class Scope < Scope
      def resolve
        features = scope.limit(10).includes(:user, square: [:user]).all.collect do |poly|
          # user_can_edit = LayersOfLondon::Booth::MapTool::PolygonPolicy.new(user, poly).update?
          poly.to_json(user_can_edit: user.present?)
        end
      end
    end
  end
end
