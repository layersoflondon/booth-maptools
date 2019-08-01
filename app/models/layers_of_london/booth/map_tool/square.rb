module LayersOfLondon::Booth::MapTool
  class Square < ApplicationRecord
    has_many :polygons

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
  end
end
