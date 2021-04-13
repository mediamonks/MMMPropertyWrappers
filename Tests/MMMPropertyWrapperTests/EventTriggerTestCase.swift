//
// MMMPropertyWrappers. Part of MMMTemple suite.
// Copyright (C) 2016-2021 MediaMonks. All rights reserved.
//

import XCTest
import MMMObservables
@testable import MMMPropertyWrappers

public protocol TestProtocol {

	var string: String { get }
	var int: Int { get }
	var double: Double { get }
	
	var didChange: SimpleEventObservable { get }
}

internal class EventTriggerTestCase: XCTestCase {
	
	enum Custom {
		case a, b, c
	}

	class Test: EventTriggerable, TestProtocol {
	
		@EventTrigger var string: String = "foo"
		@EventTrigger var int: Int = 12
		@EventTrigger var double: Double = 12.3
		@EventTrigger var custom: Custom = .a
		
		private let _didChange = LazySimpleEvent()
		public var didChange: SimpleEventObservable { _didChange }
	}
	
	private var didChangeToken: SimpleEventToken?
	
	public func testBasics() {
		
		let test = Test()
		let expectation = XCTestExpectation()
		
		test.didChange.addObserver(&didChangeToken) { _ in
			
			let t: TestProtocol = test
			
			XCTAssertEqual(t.string, "bar")
			XCTAssertEqual(t.int, 234)
			XCTAssertEqual(t.double, 23.4)
			XCTAssertEqual(test.custom, .b)
			
			expectation.fulfill()
		}
		
		XCTAssertEqual(test.string, "foo")
		
		test.string = "bar"
		test.int = 234
		test.double = 23.4
		test.custom = .b
		
		wait(for: [expectation], timeout: 2)
	}
	
}
