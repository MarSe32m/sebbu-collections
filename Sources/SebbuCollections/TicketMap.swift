//
//  TicketMap.swift
//  
//
//  Created by Sebastian Toivonen on 11.7.2023.
//

/// Implementation of Sean Parent's Russian coatcheck algorithm
///
/// Suitable for situations where items are associated to an id where the items become invalidated after some time
/// like a connection or a request. This structure also allows for far more efficient iteration over all of the elements.
public struct TicketMap<Element> {
    @usableFromInline
    internal var elements: [(id: Int, element: Element?)] = []
    
    @usableFromInline
    internal var size = 0
    
    @usableFromInline
    var currentId = 0
    
    public init() {}
    
    /// Appends a new element to the map and returns its id
    ///
    /// - Complexity: O(1)
    @inlinable
    public mutating func append(_ element: Element) -> Int {
        elements.append((currentId, element))
        defer { currentId += 1 }
        size += 1
        return currentId
    }
    
    /// Appends a sequence of elements to the map and returns their corresponding ids
    ///
    /// - Complexity: O(newElements.count)
    @inlinable
    public mutating func append(contentsOf: some Sequence<Element>) -> [Int] {
        contentsOf.map { append($0) }
    }
    
    /// Removes the element for a given index
    ///
    /// - Complexity: O(log(n))
    @inlinable
    public mutating func remove(id: Int) -> Element? {
        let element: Element?
        if let index = findIndex(of: id) {
            element = elements[index].element
            elements[index].element = nil
        } else {
            element = nil
        }
        guard let element = element else { return nil }
        
        size -= 1
        if size < elements.count / 2 {
            elements.removeAll { $0.element == nil }
        }
        return element
    }
    
    /// Returns the element for a given id
    ///
    /// - Complexity: O(log(n))
    @inlinable
    public subscript(id: Int) -> Element? {
        get {
            if let index = findIndex(of: id) {
                return elements[index].element
            } else {
                return nil
            }
        }
    }
    
    @inlinable
    internal func findIndex(of id: Int) -> Int? {
        var lowerBound = 0
        var upperBound = elements.count
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if elements[midIndex].id == id {
                return midIndex
            } else if elements[midIndex].id < id {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
}

@available(macOS 10.15.0, iOS 13.0.0, *)
extension TicketMap: Sequence {
    public struct Iterator<Element>: IteratorProtocol {
        var index = 0
        internal let ticketMap: TicketMap<Element>
        
        init(_ ticketMap: TicketMap<Element>) {
            self.ticketMap = ticketMap
        }
        
        mutating public func next() -> Element? {
            while index < ticketMap.elements.count {
                let element = ticketMap.elements[index].element
                index += 1
                if element != nil { return element }
            }
            return nil
        }
    }
    
    public func makeIterator() -> Iterator<Element> {
        Iterator(self)
    }
}
