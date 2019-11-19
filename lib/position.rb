# frozen_string_literal: true

require 'pry'
class Position
  attr_reader :position
  def initialize(position)
    @position = position
  end

  def to_s
    @position
  end

  %w[top bottom right left].each do |direction|
    define_method("#{direction}") do
      position = neighbor_position(direction)
      Position.new(position)
    end
  end

  private

  def neighbor_position(direction)
    position = Marshal.load(Marshal.dump(@position))
    case direction
    when 'top'
      position[1] += 1
    when 'bottom'
      position[1] -= 1
    when 'right'
      position[0] += 1
    when 'left'
      position[0] -= 1
    end
    position
  end
end
binding.pry