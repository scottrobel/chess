# frozen_string_literal: true

# can move up, down, right and left
class Rook < Piece
  BEHAVIORS = [
    {
      start_condition: 'none',
      directions: %w[top bottom right left],
      break_before: 'own_piece',
      take_opponent: true
    }
  ].freeze

  def behaviors
    BEHAVIORS
  end

  def to_s
    ColorizedString["\s♖\s"].colorize(color: @color.to_sym)
  end
end
