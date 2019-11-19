# frozen_string_literal: true

# can up one or two on first move
# can move one up any other move
# can only take oponent Pieces Diagonally
class Pawn
  attr_reader :position, :color, :behaviors
  def initialize(position, color)
    @position = Position.new(position)
    @color = color
    @behaviors = [
      { start_condition: 'front_line',
        iterations: 1,
        directions: %w[top],
        take_oponent: false,
        break_before: 'own_piece' }
    ]
  end
end
