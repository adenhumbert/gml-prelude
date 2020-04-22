/* Functional Programming Library by Kat @Katsaii
 * `https://github.com/NuxiiGit/functionalism`
 */
 
#region clone

/// @desc Clones a structure.
/// @param {struct} struct The structure to clone.
function struct_clone(_struct) {
	var clone = { };
	var n = variable_struct_names_count(_struct);
	var names = variable_struct_get_names(_struct);
	for (var i = n - 1; i >= 0; i -= 1) {
		var variable = names[i];
		variable_struct_set(
				clone, variable,
				variable_struct_get(_struct, variable));
	}
	return clone;
}

/// @desc Clones an array.
/// @param {array} variable The array to clone.
function array_clone(_arr) {
	if (array_length(_arr) < 1) {
		return [];
	} else {
		_arr[0] = _arr[0];
		return _arr;
	}
}

#endregion

#region iterator

/// @desc Creates a new iterator instance with this function.
/// @param {script} generator The function which will generate values for the iterator.
function Iterator(_generator) constructor {
	generator = _generator;
	has_peeked = false;
	peeked = undefined;
}

/// @desc Advance the iterator and return its next value.
/// @param {Iterator} iter The iterator to advance.
function next(_iter) {
	var item;
	if (_iter.has_peeked) {
		_iter.has_peeked = false;
		item = _iter.peeked;
	} else {
		item = _iter.generator.next();
	}
	return item;
}

/// @desc Peek at the next iterator value.
/// @param {Iterator} iter The iterator to peek at the next value of.
function peek(_iter) {
	if not (_iter.has_peeked) {
		_iter.peeked = _iter.generator.next();
		_iter.has_peeked = true;
	}
	return _iter.peeked;
}

/// @desc An exception which tells the iterator to stop running.
function StopIteration() constructor { }

/// @desc Converts an iterator into an array.
/// @param {Iterator} iter The iterator to generate values from.
function iterate(_iter) {
	var arr = [];
	try {
		for (var i = 0; true; i += 1) {
			arr[@ i] = next(_iter);
		}
	} catch (_exception) {
		if (instanceof(_exception) != "StopIteration")
		then throw _exception;
	}
	return arr;
}

#endregion

#region array

/// @desc Applies a function to all elements of an array and returns a new array.
/// @param {array} variable The array to apply the function to.
/// @param {script} f The function to apply to all elements in the array.
/// @param {int} [n] The size of the output array.
/// @param {int} [i=0] The index of the array to start at.
function array_mapf(_arr, _f) {
	var n = argument_count > 2 ? argument[2] : array_length(_arr);
	var i = argument_count > 3 ? argument[3] : 0;
	var clone = array_create(n);
	for (var j = 0; j < n; j += 1) {
		clone[@ j] = _f(_arr[j + i]);
	}
	return clone;
}

/// @desc Calls some procedure for each element of an array.
/// @param {array} variable The array to apply the function to.
/// @param {script} f The function to apply to all elements in the array.
/// @param {int} [n] The number of elements to loop through.
/// @param {int} [i=0] The index of the array to start at.
function array_foreach(_arr, _f) {
	var n = argument_count > 2 ? argument[2] : array_length(_arr);
	var i = argument_count > 3 ? argument[3] : 0;
	for (; i < n; i += 1) {
		_f(_arr[i]);
	}
}

/// @desc Converts an array into an iterator.
function array_into_iterator(_arr) {
	return new Iterator({
		arr : _arr,
		pos : 0,
		len : array_length(_arr),
		next : function() {
			if (pos < len) {
				var val = arr[pos];
				pos += 1;
				return val;
			} else {
				throw new StopIteration();
			}
		}
	});
}

#endregion

#region currying

/// @desc Curries a function which takes two arguments.
/// @param {script} ind The id of the script to apply currying to.
function curry_pair(_f) {
	return method({
		f : _f
	}, function(_a) {
		return method({
			f : self.f,
			a : _a
		}, function(_b) {
			return f(a, _b);
		});
	});
}

/// @desc Curries a function which takes three arguments.
/// @param {script} ind The id of the script to apply currying to.
function curry_trip(_f) {
	return method({
		f : _f
	}, function(_a) {
		return method({
			f : self.f,
			a : _a
		}, function(_b) {
			return method({
				f : self.f,
				a : self.a,
				b : _b
			}, function(_c) {
				return f(a, b, _c);
			});
		});
	});
}

/// @desc Curries a function which takes four arguments.
/// @param {script} ind The id of the script to apply currying to.
function curry_quad(_f) {
	return method({
		f : _f
	}, function(_a) {
		return method({
			f : self.f,
			a : _a
		}, function(_b) {
			return method({
				f : self.f,
				a : self.a,
				b : _b
			}, function(_c) {
				return method({
					f : self.f,
					a : self.a,
					b : self.b,
					c : _c
				}, function(_d) {
					return f(a, b, c, _d);
				});
			});
		});
	});
}

#endregion