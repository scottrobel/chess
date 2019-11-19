# frozen_string_literal: true

# can up one or two on first move
# can move one up any other move
# can only take oponent Pieces Diagonally
class Pawn < Piece
  BEHAVIORS = [
    { start_condition: 'self_on front_line',
      iterations: 2,
      directions: %w[top],
      take_oponent: false,
      break_before: 'own_piece' },
    {
      start_condition: 'opponent_on top_right',
      iterations: 1,
      directions: %w[top_right],
      take_oponent: true,
      break_before: 'own_piece'
    },
    {
      start_condition: 'opponent_on top_left',
      iterations: 1,
      directions: %w[top_left],
      take_oponent: true,
      break_before: 'own_piece'
    }
  ].freeze
end
