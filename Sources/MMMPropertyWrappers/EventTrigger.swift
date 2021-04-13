//
// MMMPropertyWrappers. Part of MMMTemple suite.
// Copyright (C) 2016-2021 MediaMonks. All rights reserved.
//

import Foundation
import MMMObservables

///	A wrapper that will trigger a `SimpleEvent` or `LazySimpleEvent`, e.g. `AnySimpleEvent` when the value
///	changes. The value should conform to 	`Equatable`, and the enclosing class to `EventTriggerable`.
///
///	This removes a lot of boilerplate code, going from:
///	```
///	protocol ViewModel {
///
///		var foo: String { get }
///		var bar: String { get }
///
///		var didChange: SimpleEventObservable { get }
///	}
///
///	class DefaultViewModel: ViewModel {
///
///		public private(set) var foo: String {
///			didSet {
///				_didChange.trigger(if: foo != oldValue)
///			}
///		}
///
///		public private(set) var bar: String {
///			didSet {
///				_didChange.trigger(if: bar != oldValue)
///			}
///		}
///
///		private let _didChange = SimpleEvent()
///		public var didChange: SimpleEventObservable { _didChange }
///	}
///	```
///
///	To:
///	```
///	class DefaultViewModel: ViewModel, EventTriggerable {
///
///		@EventTrigger public private(set) var foo: String
///		@EventTrigger public private(set) var bar: String
///
///		private let _didChange = SimpleEvent()
///		public var didChange: SimpleEventObservable { _didChange }
///	}
///	```
///
///	Every time `foo` or `bar` is set, and the `value != oldValue`, the `_didChange` event will trigger.
///
///	If your property does not conform to `Equatable`, you could use `@LenientEventTrigger`.
@propertyWrapper
public struct EventTrigger<Value: Equatable> {
	
	private var storage: Value
	
	public init(wrappedValue: Value) {
		self.storage = wrappedValue
	}
    
	@available(*, unavailable, message: "@EventTrigger can only be applied to classes")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
	
	public static subscript<T: EventTriggerable>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].storage
        }
        set {
			let changed = instance[keyPath: storageKeyPath].storage != newValue

			instance[keyPath: storageKeyPath].storage = newValue
			
			if case let didChange as AnySimpleEvent = instance.didChange {
				didChange.trigger(if: changed)
			} else {
				assertionFailure("Your didChange does not conform to AnySimpleEvent? (e.g. SimpleEvent / LazySimpleEvent)")
			}
        }
    }
}

/// Same as `@EventTrigger`, but without requiring to conform to `Equatable`, this will trigger every time the value hits `didSet`.
@propertyWrapper
public struct LenientEventTrigger<Value> {
	
	private var storage: Value
	
	public init(wrappedValue: Value) {
		self.storage = wrappedValue
	}
    
	@available(*, unavailable, message: "@LenientEventTrigger can only be applied to classes")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
	
	public static subscript<T: EventTriggerable>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].storage
        }
        set {
			instance[keyPath: storageKeyPath].storage = newValue
			
			if case let didChange as AnySimpleEvent = instance.didChange {
				didChange.trigger(if: true)
			} else {
				assertionFailure("Your didChange does not conform to AnySimpleEvent? (e.g. SimpleEvent / LazySimpleEvent)")
			}
        }
    }
}

public protocol EventTriggerable {
	
	var didChange: SimpleEventObservable { get }
}

// TODO: Move this to MMMObservables?
public protocol AnySimpleEvent: SimpleEventObservable {
	func trigger(`if` condition: Bool)
}

extension SimpleEvent: AnySimpleEvent {}
extension LazySimpleEvent: AnySimpleEvent {}
