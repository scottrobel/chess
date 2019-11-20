# frozen_string_literal: true

# can move up, down, right and left
class Rook < Piece
  BEHAVIORS = [
    {
      start_condition: 'none',
      iterations: 'until_break',
      directions: %w[top bottom right left],
      take_oponent: true,
      break_before: 'own_piece'
    }
  ].freeze

  def to_s
    ColorizedString["\s♖\s"].colorize(color: @color.to_sym)
  end
end
