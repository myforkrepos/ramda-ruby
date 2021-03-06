require_relative 'internal/class_which_respond_to'
require_relative 'internal/curried_method'
require_relative 'internal/dispatchable'
require_relative 'internal/function_with_arity'

module Ramda
  # Function functions
  # rubocop:disable Metrics/ModuleLength
  module Function
    extend ::Ramda::Internal::CurriedMethod
    extend ::Ramda::Internal::Dispatchable
    extend ::Ramda::Internal::ClassWhichRespondTo

    # Creates a new list iteration function from an existing one by
    # adding two new parameters to its callback function:
    # the current index, and the entire list.
    #
    # This would turn, for instance, R.map function into one that
    # more closely resembles Array.prototype.map.
    # Note that this will only work for functions in which the
    # iteration callback function is the first parameter, and where
    # the list is the last parameter. (This latter might be unimportant
    # if the list parameter is not used.)
    #
    # ((a ... -> b) ... -> [a] -> *) -> (a ..., Int, [a] -> b) ... -> [a] -> *)
    #
    curried_method(:add_index) do |f|
      curried_method_body(:add_index, f.arity) do |*args|
        idx = -1
        orig_reducer = args[0]
        xs = args[-1]
        new_reducer = ->(*reducer_args) { orig_reducer.call(*reducer_args, idx += 1, xs) }
        f.call(new_reducer, *args[1..-1])
      end
    end

    # Returns a function that always returns the given value. Note that
    # for non-primitives the value returned is a reference to the original
    # value.
    # This function is known as const, constant, or K (for K combinator)
    # in other languages and libraries.
    #
    # a -> (* -> a)
    #
    curried_method(:always) do |value|
      ->(*) { value }
    end

    # ap applies a list of functions to a list of values.
    # Dispatches to the ap method of the second argument, if present.
    # Also treats curried functions as applicatives.
    #
    # [a -> b] -> [a] -> [b]
    # Apply f => f (a -> b) -> f a -> f b
    #
    class_with_ap = class_which_responds_to(:ap)
    class_with_m = class_which_responds_to(:*)
    curried(:ap, &dispatchable(:ap, [::Array, class_with_ap, class_with_m]) do |apply_f, apply_x|
      case apply_f
      when ::Array
        apply_f.flat_map { |fn| apply_x.map(&fn) }

      when class_with_ap
        apply_f.ap(apply_x)

      when class_with_m
        apply_f * apply_x
      end
    end)

    # Applies function fn to the argument list args. This is useful
    # for creating a fixed-arity function from a variadic function.
    # fn should be a bound function if context is significant.
    #
    # (*... -> a) -> [*] -> a
    #
    curried_method(:apply) do |fn, xs|
      fn.call(*xs)
    end

    # Wraps a function of any arity (including nullary) in a function that
    # accepts exactly 2 parameters. Any extraneous parameters will not be
    # passed to the supplied function.
    #
    #
    curried_method(:binary) do |fn|
      ::Ramda.n_ary(2, fn)
    end

    # Creates a function that is bound to a context.
    #
    # (* -> *) -> {*} -> (* -> *)
    #
    curried_method(:bind) do |fn, ctx|
      fn.unbind.bind(ctx)
    end

    curried_method(:call) do |fn, *xs|
      fn.call(*xs)
    end

    # Makes a comparator function out of a function that reports whether
    # the first element is less than the second.
    #
    # (a, b -> Boolean) -> (a, b -> Number)
    #
    curried_method(:comparator) do |fn|
      lambda do |a, b|
        if fn.call(a, b)
          -1
        elsif fn.call(b, a)
          1
        else
          0
        end
      end
    end

    # Performs right-to-left function composition. The rightmost function
    # may have any arity; the remaining functions must be unary.
    #
    # Note: The result of compose is not automatically curried.
    curried_method(:compose) do |*fns|
      ::Ramda.pipe(*fns.reverse)
    end

    # Chain m => ((y -> m z), (x -> m y), ..., (a -> m b)) -> (a -> m z)
    # Returns the right-to-left Kleisli composition of the provided functions,
    # each of which must return a value of a type supported by chain.

    # R.compose_k(h, g, f) is equivalent to R.compose(R.chain(h), R.chain(g), f).
    curried_method(:compose_k) do |*fns|
      ::Ramda.compose(*(fns[0..-2].map(&::Ramda.chain) + fns[-1, 1]))
    end

    # Wraps a constructor function inside a curried function that can be called
    # with the same arguments and returns the same type.
    #
    # (* -> {*}) -> (* -> {*})
    #
    curried_method(:construct) do |constructor|
      ->(*args) { constructor.new(*args) }
    end

    # Wraps a constructor function inside a curried function that can be
    # called with the same arguments and returns the same type. The arity
    # of the function returned is specified to allow using variadic
    # constructor functions.
    #
    # Number -> (* -> {*}) -> (* -> {*})
    #
    curried_method(:construct_n) do |arity, constructor|
      ::Ramda::Internal::FunctionWithArity
        .call(arity, &constructor.method(:new))
        .curry
    end

    # Accepts a converging function and a list of branching functions and returns
    # a new function. When invoked, this new function is applied to some arguments,
    # each branching function is applied to those same arguments. The results of
    # each branching function are passed as arguments to the converging function to
    # produce the return value.
    #
    # (x1 -> x2 -> ... -> z) -> [(a -> b -> ... -> x1), ...] -> (a -> b -> ... -> z))]
    #
    curried_method(:converge) do |fn, xs, obj|
      fn.call(*xs.map { |f| f.call(obj) })
    end

    # Returns a curried equivalent of the provided function. The curried function
    # has two unusual capabilities. First, its arguments needn't be provided
    # one at a time. If f is a ternary function and g is R.curry(f),
    # the following are equivalent:
    #
    # g(1)(2)(3)
    # g(1)(2, 3)
    # g(1, 2)(3)
    # g(1, 2, 3)

    # (* -> a) -> (* -> a)
    #
    curried_method(:curry) do |fn|
      curried_method_body(:curry, fn.arity, &fn)
    end

    # Returns a curried equivalent of the provided function, with the
    # specified arity. The curried function has two unusual capabilities.
    # First, its arguments needn't be provided one at a time.
    # If g is R.curryN(3, f), the following are equivalent:
    #
    # g(1)(2)(3)
    # g(1)(2, 3)
    # g(1, 2)(3)
    # g(1, 2, 3)
    #
    # Secondly, the special placeholder value R.__ may be used to specify
    # "gaps", allowing partial application of any combination of arguments,
    # regardless of their positions.
    # If g is as above and _ is R.__, the following are equivalent:
    #
    # g(1, 2, 3)
    # g(_, 2, 3)(1)
    # g(_, _, 3)(1)(2)
    # g(_, _, 3)(1, 2)
    # g(_, 2)(1)(3)
    # g(_, 2)(1, 3)
    # g(_, 2)(_, 3)(1)
    #
    # Number -> (* -> a) -> (* -> a)
    #
    curried_method(:curry_n) do |arity, fn|
      curried_method_body(:curry_n, arity, &fn)
    end

    # Returns the empty value of its argument's type. Ramda defines the empty
    # value of Array ([]), Object ({}), String ('), and Arguments.
    # Other types are supported if they define <Type>.empty.
    #
    # Dispatches to the empty method of the first argument, if present.'))
    #
    # a -> a
    #
    curried_method(:empty) do |x|
      if x.respond_to?(:empty)
        x.empty
      elsif x.class.respond_to?(:empty)
        x.class.empty
      else
        x.class.new
      end
    end

    # Returns a new function much like the supplied one, except that the
    # first two arguments' order is reversed.
    #
    # (a -> b -> c -> ... -> z) -> (b -> a -> c -> ... -> z))
    #
    curried_method(:flip) do |fn|
      ->(a, b, *args) { fn.curry.call(b, a, *args) }.curry
    end

    # A function that does nothing but return the parameter supplied to it.
    # Good as a default or placeholder function.
    #
    # a -> a
    #
    curried_method(:identity) do |el|
      el
    end

    # Turns a named method with a specified arity into a function that can be
    # called directly supplied with arguments and a target object.
    # The returned function is curried and accepts arity + 1 parameters where
    # the final parameter is the target object.
    #
    # Number -> String -> (a -> b -> ... -> n -> Object -> *)
    #
    curried_method(:invoker) do |arity, method_name|
      ::Ramda::Internal::FunctionWithArity.call(arity + 1) do |*args, object|
        object.public_send(method_name, *args)
      end.curry
    end

    # juxt applies a list of functions to a list of values.
    #
    # [(a, b, ..., m) -> n] -> ((a, b, ..., m) -> [n])
    #
    curried_method(:juxt) do |fns, a, *bs|
      fns.map { |fn| fn.call(a, *bs) }
    end

    # "lifts" a function of arity > 1 so that it may "map over" a list,
    # Function or other object that satisfies the FantasyLand Apply spec.
    #
    # (*... -> *) -> ([*]... -> [*])
    #
    # https://stackoverflow.com/questions/36558598/cant-wrap-my-head-around-lift-in-ramda-js
    curried_method(:lift) do |fn, a, *xs|
      # ([a] + xs).reduce([curry(fn)], &ap)
      ::Ramda.lift_n(fn.arity, fn, a, *xs)
    end

    # "lifts" a function to be the specified arity, so that it may
    # "map over" that many lists, Functions or other objects that
    # satisfy the FantasyLand Apply spec.
    #
    # Number -> (*... -> *) -> ([*]... -> [*])
    #
    curried_method(:lift_n) do |arity, fn, a, *xs|
      # Applicative
      if a.respond_to?(:ap)
        xs.reduce(a.map(::Ramda.curry_n(arity, fn)), &::Ramda.ap)
      # Array
      else
        ([a] + xs).reduce([::Ramda.curry_n(arity, fn)], &::Ramda.ap)
      end
    end

    # Creates a new function that, when invoked, caches the result of calling
    # fn for a given argument set and returns the result. Subsequent calls to
    # the memoized fn with the same argument set will not result in an
    # additional call to fn; instead, the cached result for that set of arguments
    # will be returned.
    #
    # (*... -> a) -> (*... -> a)
    #
    curried_method(:memoize) do |fn|
      memo = {}

      ::Ramda::Internal::FunctionWithArity.call(fn.arity) do |*args|
        memo[args] = fn.call(*args) unless memo.key?(args)
        memo[args]
      end.curry
    end

    # Wraps a function of any arity (including nullary) in a function that
    # accepts exactly n parameters. Any extraneous parameters will not be
    # passed to the supplied function.
    #
    # Number -> (* -> a) -> (* -> a)
    #
    curried_method(:n_ary) do |arity, fn|
      ::Ramda::Internal::FunctionWithArity.call(arity) do |*args|
        fn.call(*(args.first(arity) + Array.new(fn.arity - arity, nil)))
      end.curry
    end

    # Returns a function which returns its nth argument.
    #
    # Number -> *... -> *
    #
    curried_method(:nth_arg) do |index, x, *xs|
      ([x] + xs)[index]
    end

    # Returns a singleton array containing the value provided.
    #
    # a -> [a]
    #
    curried_method(:of) do |x|
      [x]
    end

    # Accepts a function fn and returns a function that guards invocation of fn
    # such that fn can only ever be called once, no matter how many times the
    # returned function is invoked. The first value calculated is returned
    # in subsequent invocations.
    #
    # (a... -> b) -> (a... -> b)
    #
    curried_method(:once) do |fn|
      memo = {}

      ::Ramda::Internal::FunctionWithArity.call(fn.arity) do |*args|
        memo[:result] = fn.call(*args) unless memo.key?(:result)
        memo[:result]
      end.curry
    end

    # Takes a function f and a list of arguments, and returns a function g.
    # When applied, g returns the result of applying f to the arguments
    # provided initially followed by the arguments provided to g.
    #
    # ((a, b, c, ..., n) -> x) -> [a, b, c, ...] -> ((d, e, f, ..., n) -> x)
    #
    curried_method(:partial) do |fn, args|
      Ramda.curry(fn).call(*args)
    end

    # Takes a function f and a list of arguments, and returns a function g.
    # When applied, g returns the result of applying f to the arguments
    # provided to g followed by the arguments provided initially.
    #
    # ((a, b, c, ..., n) -> x) -> [d, e, f, ..., n] -> ((a, b, c, ...) -> x)
    #
    curried_method(:partial_right) do |fn, args|
      Ramda.curry(fn).call(*Array.new(fn.arity - args.size, Ramda.__) + args)
    end

    # Performs left-to-right function composition. The leftmost function may
    # have any arity; the remaining functions must be unary.
    # In some libraries this function is named sequence.
    # Note: The result of pipe is not automatically curried.
    #
    # (((a, b, ..., n) -> o), (o -> p), ..., (x -> y), (y -> z)) -> ((a, b, ..., n) -> z)
    #
    curried_method(:pipe) do |*fns|
      ->(*args) { fns[1..-1].reduce(fns[0].call(*args)) { |memo, fn| fn.call(memo) } }
    end

    # Chain m => ((a -> m b), (b -> m c), ..., (y -> m z)) -> (a -> m z)
    #
    # Returns the left-to-right Kleisli composition of the provided functions,
    # each of which must return a value of a type supported by chain.
    #
    # R.pipeK(f, g, h) is equivalent to R.pipe(f, R.chain(g), R.chain(h)).
    #
    curried(:pipe_k) do |*fns|
      ::Ramda.pipe(*(fns[0, 1] + fns[1..-1].map(&::Ramda.chain)))
    end

    # Runs the given function with the supplied object, then returns the object.
    #
    # (a -> *) -> a -> a
    #
    curried_method(:tap) do |fn, x|
      fn.call(x)
      x
    end

    # Takes a function fn, which takes a single array argument, and returns a
    # function which:
    #
    # * takes any number of positional arguments;
    # * passes these arguments to fn as an array; and
    # * returns the result.
    #
    # In other words, R.unapply derives a variadic function from a function
    # which takes an array. R.unapply is the inverse of R.apply.
    #
    # ([*...] -> a) -> (*... -> a)
    #
    curried_method(:unapply) do |fn, x, *xs|
      fn.call([x] + xs)
    end

    # Wraps a function of any arity (including nullary) in a function that
    # accepts exactly 1 parameter. Any extraneous parameters will not be passed
    # to the supplied function.
    #
    # (* -> b) -> (a -> b)
    #
    curried_method(:unary) do |fn|
      ::Ramda.n_ary(1, fn)
    end

    # Accepts a function fn and a list of transformer functions and returns
    # a new curried function. When the new function is invoked, it calls the
    # function fn with parameters consisting of the result of calling each
    # supplied handler on successive arguments to the new function.
    #
    # (x1 -> x2 -> ... -> z) -> [(a -> b -> ... -> x1), ...] -> (a -> b -> ... -> z)
    #
    curried_method(:use_with) do |fn, fns|
      ::Ramda::Internal::FunctionWithArity.call(fns.count) do |*args|
        modified_args = args.each_with_index.map do |arg, index|
          fns[index].call(arg)
        end
        fn.call(*modified_args)
      end.curry
    end
  end
end
