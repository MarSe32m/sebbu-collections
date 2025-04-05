//
//  TicketMapTests.swift
//  
//
//  Created by Sebastian Toivonen on 11.7.2023.
//

import XCTest
@testable import SebbuCollections

final class TicketMapTests: XCTestCase {
    func testBasic() {
        var ticketMap = TicketMap<Int>()
        for index in 0..<1000 {
            XCTAssertEqual(index, ticketMap.append(index))
        }
        for id in 0..<1000 {
            XCTAssertNotNil(ticketMap[id])
            XCTAssertEqual(ticketMap[id], id)
        }
        for id in 0..<1000 {
            let element = ticketMap.remove(id: id)
            XCTAssertNotNil(element)
            if let element = element {
                XCTAssertEqual(element, id)
            }
        }
    }
    
    func testIteration() {
        var ticketMap = TicketMap<String>()
        for index in 0..<1000 {
            _ = ticketMap.append("\(index)")
        }
        XCTAssertNotNil(ticketMap.remove(id: 10))
        XCTAssertFalse(ticketMap.contains(where: {$0 == "\(10)"}))
        XCTAssertNil(ticketMap[10])
    }
    
    func testSequenceAppending() {
        var ticketMap = TicketMap<Int>()
        let indices = ticketMap.append(contentsOf: (0..<1000))
        for index in indices.shuffled() {
            let element = ticketMap.remove(id: index)
            XCTAssertNotNil(element)
            if let element = element {
                XCTAssertEqual(element, index)
            }
        }
    }
}
