//
// MMMPropertyWrappers. Part of MMMTemple suite.
// Copyright (C) 2016-2021 MediaMonks. All rights reserved.
//

import Foundation

/// A wrapper that allows to set a value only once after setting the initial value. This comes in useful in instances where you
/// want to freeze the value after configuring it.
///
/// For instance on configuration object, where you want to assign a default value, but give the user the ability to alter this
/// value in a configuration callback:
///
/// ```
/// class Config {
///	    @Once var myValue: Bool = false
///	    @Once var otherValue: Bool = false
///
///	    init(_ config: (Config) -> Void) {
///	        config(self)
///	    }
///	}
///
///	// At call site
///	let config = Config {
///	    $0.myValue = true
///	}
/// ```
///
/// Now `config.myValue` is 'frozen', if you try setting it afterwards it will throw an `assertionFailure`. However,
/// `config.otherValue` is still open, since the user decided not to alter that value, so it's wise to call `.freeze()`
/// after your configuration block.
///
/// ```
///	init(_ config: (Config) -> Void) {
///	    config(self)
///
///	    _myValue.freeze()
///	    _otherValue.freeze()
///	}
/// ```
@propertyWrapper
public struct Once<T> {
	
	private var value: T
	private var didSet: Bool = false
	
	public var wrappedValue: T {
		get { value }
		set {
			guard !didSet else {
				assertionFailure("\(type(of: T.self)) can only be set once")
				return
			}
			
			value = newValue
			didSet = true
		}
	}
	
	public init(wrappedValue: T) {
		self.value = wrappedValue
	}
	
	public mutating func freeze() {
		didSet = true
	}
}
