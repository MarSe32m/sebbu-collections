//
//  BitSetTests.swift
//  
//
//  Created by Sebastian Toivonen on 3.8.2023.
//

import XCTest
@testable import SebbuCollections

final class BitSetTests: XCTestCase {
    func testBasic() {
        let size = 100
        var bitSet = BitSet(size: size)
        for i in 0..<size {
            XCTAssertFalse(bitSet[i])
        }
        for i in 0..<size where i % 2 == 0 {
            bitSet.set(i)
        }
        XCTAssertEqual(50, bitSet.cardinality)
        for i in 0..<size {
            bitSet.set(i)
        }
        XCTAssertEqual(100, bitSet.cardinality)
        for i in 0..<size {
            bitSet.clear(i)
        }
        XCTAssertEqual(0, bitSet.cardinality)
    }
}
