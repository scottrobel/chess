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

new_game = Board.new
new_game.play_game