//
// MMMPropertyWrappers. Part of MMMTemple suite.
// Copyright (C) 2016-2021 MediaMonks. All rights reserved.
//

import XCTest
@testable import MMMPropertyWrappers

fileprivate class Test {
	
	@Lazy public var counter: Int = 1
	@Lazy public private(set) var classTest = Test()
	@LazyConstant public var constant = "constant"
	
	public init(counter: Int = 1) {
		self.counter = counter
	}
	
	public func reset() {
		_counter.reset()
		_classTest.reset()
	}
	
	public func update() {
		_counter.update {
			20 + 20
		}
		_constant.update("other")
	}
}

internal class LazyTestCase: XCTestCase {

	public func testBasics() {
		
		let test = Test()
		let originalCounter = test.counter
		let originalClass = test.classTest
		let originalConstant = test.constant
		
		XCTAssertEqual(originalCounter, test.counter)
		XCTAssert(originalClass === test.classTest)
		XCTAssertEqual(originalConstant, test.constant)
		
		test.counter += 1
		
		XCTAssertGreaterThan(test.counter, originalCounter)
		
		test.reset()
		
		XCTAssert(originalClass !== test.classTest)
		XCTAssertEqual(originalCounter, test.counter)
		XCTAssertEqual(originalConstant, test.constant)
		
		let newClass = test.classTest
		
		test.update()
		
		XCTAssert(newClass === test.classTest)
		XCTAssertNotEqual(originalCounter, test.counter)
		XCTAssertNotEqual(originalConstant, test.constant)
		XCTAssertEqual(40, test.counter)
	}
	
	public func testReferenceValues() {
		
		let test = Test()
		weak var originalClass = test.classTest
		
		XCTAssert(originalClass === test.classTest)
		
		test.reset()
		
		XCTAssert(originalClass == nil)
		XCTAssert(test.classTest !== originalClass)
		XCTAssert(originalClass == nil)
	}
}
