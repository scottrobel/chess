# frozen_string_literal: true

require 'colorized_string'
require 'pry'
require './lib/position'
require './lib/pieces/piece'
require './lib/pieces/pawn'
require './lib/pieces/bishop'
require './lib/pieces/king'
require './lib/pieces/queen'
require './lib/pieces/rook'
require './lib/pieces/knight'
require './lib/board'

describe Board do
  before(:each) do
    @new_board = Board.new
  end
  describe '#set_up_pawns' do
    it 'sets up pawns' do
      @new_board.game_board[1].each do |pawn|
        expect(pawn.class).to eql(Pawn)
      end
      @new_board.game_board[6].each do |pawn|
        expect(pawn.class).to eql(Pawn)
      end
    end
  end
  describe '#back_row' do
    before(:each) do
      @back_row = @new_board.send(:back_row, 'black', 0)
      @back_row_classes = [Rook, Knight, Bishop,
                           Queen, King, Bishop, Knight, Rook]
    end
    it 'returns the correct pieces' do
      @back_row.each_with_index do |piece, index|
        expect(piece.class).to eql(@back_row_classes[index])
      end
    end
  end
  describe '#possible_moves' do
    before(:each) do
      back_row = @new_board.send(:back_row, 'black', 0)
      @piece = back_row[0]
    end
    it 'returns possible moves' do
      @new_board.send(:possible_moves, Position.new([1, 0]))
    end
  end
  describe '#display_board' do
    it 'displays board' do
      @new_board.send(:display_board)
    end
  end
end
