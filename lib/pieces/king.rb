# frozen_string_literal: true

# can move in any direction 1 move
# can not move into check
class King < Piece
  BEHAVIORS = [
    {
      start_condition: 'none',
      iterations: 1,
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
      break_before: 'opponent_moves'
    }
  ].freeze

  def to_s
    ColorizedString["\s♔\s"].colorize(color: @color.to_sym)
  end
end
