# frozen_string_literal: true

class Board
  def initialize
    @game_board = Array.new(8) { Array.new(8) { "\s" * 3 } }
  end
end
