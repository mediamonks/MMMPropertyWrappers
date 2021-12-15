//
// MMMPropertyWrappers. Part of MMMTemple suite.
// Copyright (C) 2016-2021 MediaMonks. All rights reserved.
//

import Foundation

/// Same as `@Lazy`, only without the ability to change the value.
@propertyWrapper
public struct LazyConstant<Value> {
	
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
