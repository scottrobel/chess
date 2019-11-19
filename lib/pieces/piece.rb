# frozen_string_literal: true

class Piece
  attr_reader :position, :color
  def initialize(position, color)
    @position = Position.new(position)
    @color = color
  end
end
