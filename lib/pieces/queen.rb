# frozen_string_literal: true

# can move diagonal
class Queen < Piece
  BEHAVIORS = [
    {
      start_condition: 'none',
      directions:
      %w[top
         bottom
         right
         left
         top_right
         top_left
         bottom_right
         bottom_left],
      take_opponent: true,
    }
  ].freeze


  def behaviors
    BEHAVIORS
  end

  def to_s
    ColorizedString["\s♕\s"].colorize(color: @color.to_sym)
  end
end
