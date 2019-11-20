require 'colorized_string'
require 'pry'
require './lib/position'
require './lib/pieces/piece'
require './lib/pieces/pawn'
require './lib/board'

describe Board do
  before(:each) do
    @new_board = Board.new
  end
  describe '#set_up_pawns' do
    before(:each) do
      @new_board.set_up_pawns
    end
    it 'sets up pawns' do
      @new_board.game_board[1].each do |pawn|
        expect(pawn.class).to eql(Pawn)
      end
      @new_board.game_board[6].each do |pawn|
        expect(pawn.class).to eql(Pawn)
      end
    end
  end
end
