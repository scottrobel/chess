# frozen_string_literal: true

# contains a position and can eturn positions around ity
class Position
  attr_reader :value
  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  %w[top bottom right left].each do |direction|
    define_method(direction.to_s) do
      value = neighbor_position(direction)
      Position.new(value)
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
    position = Marshal.load(Marshal.dump(@value))
    position[1] += 1 if direction == 'top'
    position[1] -= 1 if direction == 'bottom'
    position[0] += 1 if direction == 'right'
    position[0] -= 1 if direction == 'left'
    position
  end
end
