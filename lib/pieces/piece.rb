# frozen_string_literal: true

class Piece
  attr_reader :color
  attr_accessor :position
  def initialize(position, color)
    @position = Position.new(position)
    @color = color
  end
end
