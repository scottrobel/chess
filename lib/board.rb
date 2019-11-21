# frozen_string_literal: true

# contains all pieces and methods to return data about
# the pieces on the board
class Board
  attr_reader :game_board
  def initialize
    @game_board = Array.new(8) { Array.new(8) { "\s" * 3 } }
    set_up_pawns
    @game_board[0] = back_row('black', 0)
    @game_board[7] = back_row('white', 7)
  end

  private

  def make_move(position_of_piece, position_to_move)
    piece = position_to_value(position_of_piece)
    piece.position = position_to_move
    start_position_value = position_of_piece.value
    end_position_value = position_to_move.value
    @game_board[end_position_value[1]][end_position_value[0]] = piece
    @game_board[start_position_value[1]][start_position_value[0]] = "\s" * 3
  end

  def default_color_array
    color_array = Array.new(8) do |row_i|
      Array.new(8) do |piece_i|
        (row_i + piece_i).even? ? :red : :light_black
      end
    end
  end

  def display_possible_moves(piece_position)
    possible_moves = possible_moves(piece_position)
    color_array = default_color_array
    position_value = piece_position.value
    color_array[position_value[1]][position_value[0]] = :blue
    possible_moves.each do |possible_move|
      move_position = possible_move.value
      color_array[move_position[1]][move_position[0]] = :green
    end
    display_board(color_array)
  end

  def display_board(color_array = default_color_array)
    print "\n"
    board = @game_board.map.with_index do |row, row_index|
      row.map.with_index do |piece, piece_index|
        color = color_array[row_index][piece_index]
        ColorizedString[piece.to_s].colorize(background: color.to_sym)
      end.join + "\n"
    end.join
    print board
  end

  def possible_moves(piece_position)
    piece = position_to_value(piece_position)
    player_color = piece.color
    behaviors = piece.behaviors
    possible_moves = []
    behaviors.each do |behavior|
      next unless test_start_condition(behavior[:start_condition], piece)

      behavior[:directions].each do |direction|
        iterator = 0
        position = piece_position
        loop do
          if !behavior[:iterations].nil? && iterator == behavior[:iterations]
            break
          end

          position = direction.split(' ').inject(position) do |new_position, next_direction|
            new_position.method(next_direction.to_sym).call
          end
          break unless on_board?(position)
          value = position_to_value(position)
          if empty_space?(value)
            possible_moves << position
          elsif my_piece?(value, player_color)
            break
          elsif behavior[:take_opponent]
            possible_moves << position
            break
          else
            break
          end
          iterator += 1
        end
      end
    end
    possible_moves
  end

  def test_start_condition(start_condition, piece)
    return true if start_condition == 'none'

    player_color = piece.color
    split_condition = start_condition.split(' ')
    case split_condition[0]
    when 'self_on'
      if split_condition[1] == 'front_line'

        player_front_line = player_color == 'white' ? 6 : 1
        return piece.position.value[1] == player_front_line
      end
    when 'opponent_on'
      direction = split_condition[1]
      possible_opponent_position = piece.position.method(direction.to_sym).call
      value_of_position = position_to_value(possible_opponent_position)
      return opponent_piece?(value_of_position, player_color)
    end
  end

  def empty_space?(value)
    value == "\s" * 3
  end

  def my_piece?(value, player_color)
    !empty_space?(value) && value.color == player_color
  end

  def opponent_piece?(value, player_color)
    !empty_space?(value) && value.color = !player_color
  end

  def on_board?(position)
    coordinate = position.value
    coordinate.all? { |linear_position| (0..7).include?(linear_position) }
  end

  def position_to_value(position)
    coordinate = position.value
    @game_board[coordinate[1]][coordinate[0]]
  end

  def set_up_pawns
    @game_board[1] = Array.new(8) do |x_index|
      Pawn.new([x_index, 1], 'black')
    end
    @game_board[6] = Array.new(8) do |x_index|
      Pawn.new([x_index, 6], 'white')
    end
  end

  def back_row(color, row)
    positions = [Rook, Knight, Bishop,
                 Queen, King, Bishop, Knight, Rook]
    Array.new(8) do |x_index|
      positions[x_index].new([x_index, row], color)
    end
  end
end
