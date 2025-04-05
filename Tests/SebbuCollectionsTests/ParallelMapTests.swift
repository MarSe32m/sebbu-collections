//
//  ParallelMapTests.swift
//  sebbu-collections
//
//  Created by Sebastian Toivonen on 5.4.2025.
//

import XCTest
@testable import SebbuCollections

final class ParallelMapTests: XCTestCase {
    func testParallelMap() {
        let range = (0..<1_000_000)
        let array = Array(range)
        let mapped = range.map { $0 * $0 }
        
        let rangeParallelMapped1 = range.parallelMap { $0 * $0 }
        let rangeParallelMapped2 = range.parallelMap(parallelism: 2) { $0 * $0 }
        let rangeParallelMapped3 = range.parallelMap(blockSize: .random(in: 2...10)) { $0 * $0 }
        let rangeParallelMapped4 = range.parallelMap(parallelism: 3, blockSize: .random(in: 2...10)) { $0 * $0 }
        XCTAssertEqual(mapped, rangeParallelMapped1)
        XCTAssertEqual(mapped, rangeParallelMapped2)
        XCTAssertEqual(mapped, rangeParallelMapped3)
        XCTAssertEqual(mapped, rangeParallelMapped4)
        
        let arrayParallelMapped1 = array.parallelMap { $0 * $0 }
        let arrayParallelMapped2 = array.parallelMap(parallelism: 2) { $0 * $0 }
        XCTAssertEqual(mapped, arrayParallelMapped1)
        XCTAssertEqual(mapped, arrayParallelMapped2)
        
        let slice = array[0..<1_000]
        let sliceParallelMapped1 = slice.parallelMap { $0 * $0 }
        let sliceParallelMapped2 = slice.parallelMap(parallelism: 2) { $0 * $0 }
        XCTAssertEqual(slice.map { $0 * $0 }, sliceParallelMapped1)
        XCTAssertEqual(slice.map { $0 * $0 }, sliceParallelMapped2)
        
    }
}
