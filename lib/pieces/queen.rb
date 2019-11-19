# frozen_string_literal: true

# can move diagonal
class Queen < Piece
  BEHAVIORS = [
    {
      start_condition: 'none',
      iterations: 'until_break',
      directions:
      %w[top
         bottom
         right
         left
         top_right
         top_left
         bottom_right
         bottom_left],
      take_oponent: true,
      break_before: 'own_piece'
    }
  ].freeze
end