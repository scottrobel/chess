# frozen_string_literal: true

# can move up, down, right and left
class Rook
  attr_reader :position, :color
  def initialize(position, color)
    @position = Position.new(position)
    @color = color
  end
end
