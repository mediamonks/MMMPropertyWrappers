//
// MMMPropertyWrappers. Part of MMMTemple suite.
// Copyright (C) 2016-2021 MediaMonks. All rights reserved.
//

import XCTest
@testable import MMMPropertyWrappers

#if os(iOS) || os(macOS)
import CwlPreconditionTesting
#else
import CwlPosixPreconditionTesting
#endif

internal class OnceTestCase: XCTestCase {

	enum Custom {
		case a, b, c
	}

	struct Test {
		@Once var string: String = "foo"
		@Once var int: Int = 12
		@Once var double: Double = 12.3
		@Once var custom: Custom = .a
		
		mutating func freeze() {
			_string.freeze()
			_int.freeze()
			_double.freeze()
			_custom.freeze()
		}
	}

	public func testBasics() {
		
		var test = Test()
		
		XCTAssertEqual(test.string, "foo")
		XCTAssertEqual(test.int, 12)
		XCTAssertEqual(test.double, 12.3)
		XCTAssertEqual(test.custom, .a)
		
		test.string = "bar"
		test.int = 20
		test.double = 0.2
		test.custom = .b
		
		XCTAssertEqual(test.string, "bar")
		XCTAssertEqual(test.int, 20)
		XCTAssertEqual(test.double, 0.2)
		XCTAssertEqual(test.custom, .b)
		
		XCTAssertNotNil(catchBadInstruction {
			test.string = "baz"
		})
		XCTAssertNotNil(catchBadInstruction {
			test.int = 300
		})
		XCTAssertNotNil(catchBadInstruction {
			test.double = 5000.02
		})
		XCTAssertNotNil(catchBadInstruction {
			test.custom = .c
		})
		
		XCTAssertEqual(test.string, "bar")
		XCTAssertEqual(test.int, 20)
		XCTAssertEqual(test.double, 0.2)
		XCTAssertEqual(test.custom, .b)
	}
	
	public func testFreeze() {
		
		var test = Test()
		
		XCTAssertEqual(test.string, "foo")
		
		test.freeze()
		
		XCTAssertNotNil(catchBadInstruction {
			test.string = "baz"
		})
		
		XCTAssertEqual(test.string, "foo")
	}
}
