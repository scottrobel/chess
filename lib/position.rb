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
    define_method(direction.to_s) do
      position = neighbor_position(direction)
      Position.new(position)
    end
  end

  %w[top bottom].each do |vertical_direction|
    %w[right left].each do |horizontal_direction|
      method_name = "#{vertical_direction}_#{horizontal_direction}"
      define_method(method_name) do
        shift_one = method(vertical_direction.to_s.to_sym).call
        shift_one.method(horizontal_direction.to_s.to_sym).call
      end
    end
  end

  private

  def neighbor_position(direction)
    position = Marshal.load(Marshal.dump(@position))
    position[1] += 1 if direction == 'top'
    position[1] -= 1 if direction == 'bottom'
    position[0] += 1 if direction == 'right'
    position[0] -= 1 if direction == 'left'
    position
  end
end
position = Position.new([1, 1])
tr = position.top_right
binding.pry
