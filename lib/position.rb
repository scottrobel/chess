# frozen_string_literal: true

class Position
  def initialize(position)
    @position = position
  end

  def to_s
    @position
  end

  private

  def neighbor_position(direction)
    position = Marshal.load(Marshal.dump(@position))
    case direction
    when 'top'
      position[1] += 1
    when 'bottom'
      position[1] -= 1
    when 'right'
      position[0] += 1
    when 'left'
      position[0] -= 1
    end
  end
end
