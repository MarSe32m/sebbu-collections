//
//  RingBufferTests.swift
//  
//
//  Created by Sebastian Toivonen on 11.8.2023.
//


import XCTest
@testable import SebbuCollections

final class RingBufferTests: XCTestCase {
    func testBasic() {
        var buffer = RingBuffer<Int>(size: 2000)
        XCTAssertEqual(buffer.capacity, 2000)
        for i in 0..<1000 {
            buffer.append(i)
            buffer.prepend(i)
        }
        for i in (0..<1000).reversed() {
            XCTAssertEqual(buffer.removeFirst(), i)
            XCTAssertEqual(buffer.removeLast(), i)
        }
        for i in 0..<1000 {
            buffer.append(i)
        }
        for i in 0..<1000 {
            XCTAssertEqual(buffer[i], i)
        }
    }
    
    func testIteration() {
        var buffer = RingBuffer<Int>(size: 1000)
        for i in 0..<1000 {
            buffer.append(i)
        }
        for (index, element) in buffer.enumerated() {
            XCTAssertEqual(index, element)
        }
    }
    
    func testSequenceAppending() {
        let values = (0..<1000)
        var buffer = RingBuffer<Int>(size: 1000)
        buffer.append(contentsOf: values)
        for (index, element) in buffer.enumerated() {
            XCTAssertEqual(index, element)
        }
    }
}
