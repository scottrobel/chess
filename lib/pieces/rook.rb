# frozen_string_literal: true

# can move up, down, right and left
class Rook
  BEHAVIORS = [
    {
      start_condition: 'none',
      iterations: 'until_break',
      directions: %w[top bottom right left],
      take_oponent: true,
      break_before: 'own_piece'
    }
  ].freeze
  attr_reader :position, :color
  def initialize(position, color)
    @position = Position.new(position)
    @color = color
  end
end
