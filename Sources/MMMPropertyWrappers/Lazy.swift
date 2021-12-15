//
// MMMPropertyWrappers. Part of MMMTemple suite.
// Copyright (C) 2016-2021 MediaMonks. All rights reserved.
//

import Foundation

/// A wrapper that only generates the value opon accessing it, it's similar to `lazy var` except you have the ability to
/// `reset()` the value to a `nil` state. This saves memory in some cases, as well as gives the oportunity to execute the
/// (auto)closure again.
///
/// ```
///	@Lazy public private(var) foo = Bar()
///	@Lazy public private(var) baz = "Foo"
///
///	// Now Bar will be initialized
///	print(foo)
///
/// // Can be upated like usual
/// baz = "Foo2"
///
///	// Reset the state, we must access reference to the wrapper.
///	_foo.reset()
///	_baz.reset()
///
///	// Now the baz will read "Foo" again, since we just reset it.
///	print(baz) == "Foo"
///
///	// Update the initialiser. This will reset as well.
///	_foo.update(Bar(flag: true))
/// ```
///
/// For more info and examples, look at `LazyTestCase`.
@propertyWrapper
public struct Lazy<Value> {
	
	private var factory: () -> Value
	
	public init(wrappedValue: @autoclosure @escaping () -> Value) {
		self.factory = wrappedValue
	}
	
	public init(wrappedValue: @escaping () -> Value) {
		self.factory = wrappedValue
	}
	
	private var _wrappedValue: Value?
	public var wrappedValue: Value {
		mutating get {
			if let wrappedValue = _wrappedValue {
				return wrappedValue
			}
			
			let value = factory()
			_wrappedValue = value
			return value
		}
		set {
			_wrappedValue = newValue
		}
	}
	
	/// Resets the lazy value, so the closure to generate will be called again upon access.
	public mutating func reset() {
		_wrappedValue = nil
	}
	
	/// Update the autoclosure for generating the lazy value. This will also reset the value.
	/// - Parameter wrappedValue: The new value.
	public mutating func update(_ wrappedValue: @autoclosure @escaping () -> Value) {
		reset()
		factory = wrappedValue
	}
	
	/// Update the closure for generating the lazy value. This will also reset the value.
	/// - Parameter wrappedValue: The new closure to generate the value.
	public mutating func update(_ wrappedValue: @escaping () -> Value) {
		reset()
		factory = wrappedValue
	}
}
