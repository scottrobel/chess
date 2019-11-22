# frozen_string_literal: true

# can up one or two on first move
# can move one up any other move
# can only take oponent Pieces Diagonally
class Pawn < Piece
  BEHAVIORS = [
    {
      iterations: 2,
      take_opponent: false,
      break_before: 'own_piece'
    },
    {
      iterations: 1,
      take_opponent: true,
      break_before: 'own_piece'
    },
    {
      iterations: 1,
      take_opponent: true,
      break_before: 'own_piece'
    },
    {
      iterations: 1,
      take_opponent: false,
      break_before: 'own_piece'
    }
  ].freeze
  def behaviors
    direction_beginning = @color == 'black' ? 'top' : 'bottom'
    direction_end = ['', '_right', '_left', '']
    BEHAVIORS.map.with_index do |behavior, index|
      direction = "#{direction_beginning}#{direction_end[index]}"
      behavior[:directions] = [direction]
      behavior['start_condition'.to_sym] = 'self_on front_line' if index == 0
      behavior['start_condition'.to_sym] = "opponent_on #{direction}" if index < 3 && index > 0
      behavior['start_condition'.to_sym] = 'none' if index == 3
      behavior
    end
  end

  def to_s
    ColorizedString["\s♙\s"].colorize(color: @color.to_sym)
  end
end
