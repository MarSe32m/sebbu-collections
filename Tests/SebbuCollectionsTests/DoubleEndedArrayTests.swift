//
//  DoubleEndedArrayTests.swift
//  
//
//  Created by Sebastian Toivonen on 8.8.2023.
//

import XCTest
@testable import SebbuCollections

final class DoubleEndedArrayTests: XCTestCase {
    func testBasic() {
        var array = DoubleEndedArray<Int>()
        for i in 0..<1000 {
            array.append(i)
            array.prepend(i)
        }
        for i in (0..<1000).reversed() {
            XCTAssertEqual(array.removeFirst(), i)
            XCTAssertEqual(array.removeLast(), i)
        }
        for i in 0..<1000 {
            array.append(i)
        }
        for i in 0..<1000 {
            XCTAssertEqual(array[i], i)
        }
    }
    
    func testIteration() {
        var array = DoubleEndedArray<Int>()
        for i in 0..<1000 {
            array.append(i)
        }
        for (index, element) in array.enumerated() {
            XCTAssertEqual(index, element)
        }
    }
    
    func testSequenceAppending() {
        let values = (0..<1000)
        var array = DoubleEndedArray<Int>()
        array.append(contentsOf: values)
        for (index, element) in array.enumerated() {
            XCTAssertEqual(index, element)
        }
    }

    func testArrayLiteral() {
        let array: DoubleEndedArray<Int> = [0, 1, 2, 3, 4, 5]
        for (index, element) in array.enumerated() {
            XCTAssertEqual(index, element)
        }
    }
}
