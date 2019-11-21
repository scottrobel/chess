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
  describe '#display_possible_moves' do
    it 'displays possible pawn moves' do
      @new_board.send(:display_possible_moves, Position.new([0, 1]))
    end
  end
  describe '#make_move' do
    it 'can move a pawn' do
      @new_board.send(:make_move, Position.new([0, 1]), Position.new([0, 3]))
      @new_board.send(:display_possible_moves, Position.new([0, 3]))
      @new_board.send(:display_possible_moves, Position.new([0, 0]))
    end
  end
  describe '#player_positions' do
    it 'can get white positions' do
      expect(@new_board.send(:player_positions, 'white').size).to eql(16)
    end
  end
  describe '#player_piece?' do
    it 'returns true if its the players piece' do
      expect(@new_board.send(:player_piece?, 'black', Position.new([0,0]))).to eql(true)
    end
  end

  describe '#piece_moveable' do
    it 'returns false when a rook is trapped' do
      expect(@new_board.send(:piece_moveable?, Position.new([0,0]))).to eql(false)
    end
    it 'returns true when a piece is moveable' do
      expect(@new_board.send(:piece_moveable?, Position.new([0,1]))).to eql(true)
    end
  end
  describe '#select_piece' do
    xit 'takes input' do
      @new_board.send(:select_piece, 'black')
    end
  end
  describe '#select_position_to_move' do
    xit 'select a position to move' do
      @new_board.send(:select_position_to_move, Position.new([0,1]))
    end
  end
  describe '#select_position_to_move' do
    it 'select a position to move' do
      @new_board.send(:player_turn, 'black')
    end
  end
end
