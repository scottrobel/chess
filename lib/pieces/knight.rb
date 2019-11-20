# frozen_string_literal: true

# can move two up one over
class Knight < Piece
  BEHAVIORS = [
    {
      start_condition: 'none',
      iterations: 1,
      directions:
      ['top top_right',
       'top top_left',
       'right top_right',
       'right bottom_right',
       'bottom bottom_right',
       'bottom bottom_left',
       'left top_left',
       'left bottom_left'],
      take_opponent: true,
      break_before: 'own_piece'
    }
  ].freeze

  def behaviors
    BEHAVIORS
  end

  def to_s
    ColorizedString["\s♘\s"].colorize(color: @color.to_sym)
  end
end
