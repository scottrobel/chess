# frozen_string_literal: true

class Board
  attr_reader :game_board
  def initialize
    @game_board = Array.new(8) { Array.new(8) { "\s" * 3 } }
  end

  private

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
