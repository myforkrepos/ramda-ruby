require_relative 'internal/curried_method'

module Ramda
  # Math functions
  module Math
    extend ::Ramda::Internal::CurriedMethod

    # Add two values.
    #
    # Number -> Number -> Number
    #
    curried_method(:add) do |a, b|
      a + b
    end

    # Decrements its argument.
    #
    # Number -> Number
    #
    curried_method(:dec) do |a|
      a - 1
    end

    # Divides two numbers. Equivalent to a / b.
    #
    # Number -> Number -> Number
    #
    curried_method(:divide) do |a, b|
      a.fdiv(b)
    end

    # Increments its argument.
    #
    # Number -> Number
    #
    curried_method(:inc) do |a|
      a + 1
    end

    curried_method(:math_mod) do |x, y|
      #  if (!_isInteger(m)) { return NaN; }
      #  if (!_isInteger(p) || p < 1) { return NaN; }
      #  return ((m % p) + p) % p;
    end

    # Returns the mean of the given list of numbers.
    #
    # [Number] -> Number
    #
    curried_method(:mean) do |xs|
      size = xs.size

      if size.zero?
        Float::NAN
      else
        xs.reduce(&:+).fdiv(size)
      end
    end

    # Returns the median of the given list of numbers.
    #
    # [Number] -> Number
    #
    curried_method(:median) do |xs|
      sorted = xs.sort
      size = sorted.size

      if size.zero?
        Float::NAN
      elsif size.odd?
        sorted[size / 2]
      else
        sorted[size / 2 - 1, 2].reduce(&:+).fdiv(2)
      end
    end

    # Divides the first parameter by the second and returns the remainder.
    #
    # Number -> Number -> Number
    #
    curried_method(:modulo) do |a, divider|
      a % divider
    end

    # Multiplies two numbers. Equivalent to a * b but curried.
    #
    # Number -> Number -> Number
    #
    curried_method(:multiply) do |a, b|
      a * b
    end

    # Negates its argument.
    #
    # Number -> Number
    #
    curried_method(:negate, &:-@)

    # Multiplies together all the elements of a list.
    #
    # [Number] -> Number
    #
    curried_method(:product) do |xs|
      xs.reduce(:*)
    end

    # Subtracts its second argument from its first argument.
    #
    # Number -> Number -> Number
    #
    curried_method(:subtract) do |a, b|
      a - b
    end

    # Adds together all the elements of a list.
    #
    # [Number] -> Number
    #
    curried_method(:sum) do |xs|
      xs.reduce(:+)
    end
  end
end
