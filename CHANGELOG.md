Not Released
---------------

Release 0.16.0
---------------

* [compose_k](http://ramdajs.com/docs/#composeK)
* [drop_last](http://ramdajs.com/docs/#dropLast)
* [drop_last_while](http://ramdajs.com/docs/#dropLastWhile)
* [pipe_k](http://ramdajs.com/docs/#pipeK)
* [prop_is](http://ramdajs.com/docs/#propIs)
* [prop_satisfies](http://ramdajs.com/docs/#propSatisfies)
* [split_every](http://ramdajs.com/docs/#splitEvery)
* [take_last](http://ramdajs.com/docs/#takeLast)
* [take_last_while](http://ramdajs.com/docs/#takeLastWhile)
* [uniq_by](http://ramdajs.com/docs/#uniqBy)

Release 0.15.0
---------------

Added:

* [add_index](http://ramdajs.com/docs/#addIndex)
* [identical](http://ramdajs.com/docs/#identical)
* [reduced](http://ramdajs.com/docs/#reduced)


Release 0.14.0
---------------

Added:

* (pending) uncurry_n
* [adjust](http://ramdajs.com/docs/#adjust)
* [drop_repeats](http://ramdajs.com/docs/#dropRepeats)
* [drop_repeats_with](http://ramdajs.com/docs/#dropRepeatsWith)
* [intersperse](http://ramdajs.com/docs/#intersperse)
* [mean](http://ramdajs.com/docs/#mean)
* [median](http://ramdajs.com/docs/#median)
* [to_string](http://ramdajs.com/docs/#toString)
* [where_eq](http://ramdajs.com/docs/#whereEq)

Release 0.12.0
---------------

Added:

* [aperture](http://ramdajs.com/docs/#aperture)
* [both](http://ramdajs.com/docs/#both)
* [either](http://ramdajs.com/docs/#either)
* [into](http://ramdajs.com/docs/#into)
* [none](http://ramdajs.com/docs/#none)
* [test](http://ramdajs.com/docs/#test)
* [transduce](http://ramdajs.com/docs/#transduce)

Transducers for:

* filter
* map
* take

Release 0.11.0
---------------

Added:

* dissoc_path

Release 0.10.0
---------------

Added:

* (pending) compose_p
* (pending) pipe_p
* (pending) map_accum
* (pending) map_accum_right
* default_to
* merge_all
* partial
* partial_right
* scan
* unfold


Release 0.9.0
---------------

Added debug_mode which shows name, arguments and result of each function call.

Small performance improvements.

Added:

* call
* drop_while
* evolve
* init
* insert_all
* invert
* invert_obj
* map_obj_indexed
* nth_arg


Release 0.8.1
---------------

Added ability to change exceptions handler.
Added benchmarks.

Release 0.8.0
---------------

Added:

* assoc_path
* lens - composition does not work compose(lens1, lensb)
* lens_index
* lens_path
* lens_prop
* max_by
* min_by
* negate
* over
* pick_by
* set
* type
* unapply
* view
* update

Release 0.7.0
---------------

Added:

* apply
* has
* has_in
* lift
* lift_n
* path_eq

Release 0.6.0
---------------

Added:

* F
* T
* `__` - first function call should have all arguments `g(__2, __)(1, 3)`, this means that it doesn't support `g(__, 2)(1)(3)`, `g(__, 2)(1, 3)` and `g(__, 2)(__, 3)(1)`
* bind
* cond
* prop_or
* replace - it uses a gsub method and global replacement
* trim

Release 0.5.0
---------------

Added:

* curry_n

Release 0.4.0
---------------

Added:

* (pending) to_pairs_in
* construct_n
* to_pairs

Release 0.3.0
---------------

Added:

* (pending) math_mod
* ap
* chain
* complement
* empty - uses x.class.new for defining new empty object if empty method
  does not exist
* from_pairs
* is
* of
* unnest
* zip_obj

Release 0.2.3
---------------

Added:

* times

Release 0.2.2
---------------

Added:

* insert
* remove

Release 0.2.0
---------------

Added:

* binary
* path
* unary
* uniq_with - first argument is a function with 1 arity which transforms
  each list element and applies uniq function to results
* (pending) keys_in
* (pending) values_in

Release 0.1.4
---------------

Added:

* last
* partition
* juxt
* slice

Release 0.1.1
---------------

Breaking changes: index_of, last_index_of return nil instead of -1 if element
can't be found

Added:

* find_index - returns nil if index doesn't exist
* find_last
* find_last_index - returns nil if index doesn't exist
* for_each
* modulo
* repeat
* where

Release 0.1.0
---------------

* add
* all
* all_pass
* always
* and
* any
* any_pass
* append
* assoc
* clone
* comparator
* compose
* concat
* construct
* contains
* converge
* count_by
* curry
* dec
* difference
* difference_with
* dissoc
* divide
* drop
* eq_by
* eq_props
* equals
* filter
* find
* flatten
* flip
* group_by
* gt
* gte
* head
* identity
* if_else
* inc
* index_of
* intersection
* invoker
* is_empty
* is_nil
* join
* keys
* last_index_of
* length
* lt
* lte
* map
* match
* max
* memoize
* merge
* min
* multiply
* n_ary
* not
* nth
* omit
* once
* or
* pick
* pick_all
* pipe
* pluck
* prepend
* product
* project
* prop
* prop_eq
* props
* range
* reduce
* reduce_right
* reject
* reverse
* sort
* sort_by
* split
* subtract
* sum
* tail
* take
* take_while
* tap
* to_lower
* to_upper
* union
* union_with
* uniq
* use_with
* values
* xprod
* zip
* zip_with
