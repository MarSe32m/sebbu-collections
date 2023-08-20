//
//  DoubleEndedArray.swift
//  
//
//  Created by Sebastian Toivonen on 8.8.2023.
//

/// Double ended array, similar to a Deque from the swift-collections module.
/// Supports efficient amortized O(1) complexity appending and prepending operations. 
/// Random access is O(1) also. 
public struct DoubleEndedArray<Element> {
    @usableFromInline
    internal var buffer: [Element?] = []
    
    @usableFromInline
    internal var headIndex: Int = 0
    
    @usableFromInline
    internal var tailIndex: Int = 0

    @inlinable
    public var count: Int {
        return tailIndex >= headIndex ? tailIndex - headIndex : buffer.count - headIndex + tailIndex
    }

    @_transparent
    public var capacity: Int {
        return buffer.count
    }
    
    @_transparent
    public var isEmpty: Bool {
        tailIndex == headIndex
    }

    public init() {
        buffer = [Element?](repeating: nil, count: 2)
    }

    public init(reservingCapacity: Int) {
        assert(reservingCapacity >= 2, "The capacity of a DoubleEndedArray must be atleast two")
        buffer = [Element?](repeating: nil, count: reservingCapacity)
    }

    @inlinable
    public subscript(index: Int) -> Element {
        get {
            assert(index >= 0, "Index out of bounds")
            assert(index < count, "Index out of bounds")
            return buffer[(headIndex + index) % buffer.count]!
        }
        set {
            assert(index >= 0, "Index out of bounds")
            assert(index < count, "Index out of bounds")
            buffer[(headIndex + index) % buffer.count] = newValue
        }
    }

    /// Appending an element is an amortized O(1) operation
    @inlinable
    public mutating func append(_ element: Element) {
        if tailIndex == headIndex || (tailIndex + 1) % buffer.count != headIndex {
            buffer[tailIndex] = element
            tailIndex = (tailIndex + 1) % buffer.count
        } else {
            _grow()
            append(element)
        }
    }

    /// Appending a sequence of elements is a O(*n*) operation where *n* is the amount elements in the sequence
    @inlinable
    public mutating func append<S: Sequence>(contentsOf: S) where S.Element == Element {
        for element in contentsOf {
            append(element)
        }
    }

    /// Prepending an  element is an amortized O(1) operation
    @inlinable
    public mutating func prepend(_ element: Element) {
        if headIndex == tailIndex || (headIndex + buffer.count - 1) % buffer.count != tailIndex {
            headIndex = (headIndex + buffer.count - 1) % buffer.count
            buffer[headIndex] = element
        } else {
            _grow()
            prepend(element)
        }
    }

    /// Prepending a sequence of elements is a O(*n*) operation where *n* is the amount elements in the sequence
    @inlinable
    public mutating func prepend<S: Sequence>(contentsOf: S) where S.Element == Element {
        for element in contentsOf {
            prepend(element)
        }
    }

    /// Popping an element is an O(1) operation
    @inlinable
    public mutating func popFirst() -> Element? {
        if isEmpty { return nil }
        let element = buffer[headIndex]
        buffer[headIndex] = nil
        headIndex = (headIndex + 1) % buffer.count
        return element
    }

    /// Popping an element is an O(1) operation
    @inlinable
    public mutating func popLast() -> Element? {
        if isEmpty { return nil }
        let element = buffer[(tailIndex - 1 + buffer.count) % buffer.count]
        buffer[(tailIndex - 1 + buffer.count) % buffer.count] = nil
        tailIndex = (tailIndex - 1 + buffer.count) % buffer.count
        return element
    }

    /// Removing the first element is an O(1) operation
    @inlinable
    public mutating func removeFirst() -> Element {
        assert(!isEmpty)
        return popFirst()!
    }

    /// Removing the last element is an O(1) operation
    @inlinable
    public mutating func removeLast() -> Element {
        assert(!isEmpty)
        return popLast()!
    }

    @inlinable
    public mutating func reserveCapacity(_ newCapacity: Int) {
        if buffer.count >= newCapacity { return }
        _grow(newCapacity: newCapacity)
    }

    @inlinable
    public mutating func removeAll(keepingCapacity: Bool = false) {
        if keepingCapacity {
            for i in 0..<buffer.count {
                buffer[i] = nil
            }
        } else {
            buffer = [Element?](repeating: nil, count: 2)
        }
        tailIndex = 0
        headIndex = 0
    }

    @inlinable
    internal mutating func _grow(newCapacity: Int? = nil) {
        let newCapacity = newCapacity ?? Int((1.618 * Double(buffer.count)).rounded(.up))
        var newBuffer = [Element?](repeating: nil, count: newCapacity)
        var _tailIndex = 0
        while headIndex != tailIndex {
            newBuffer[_tailIndex] = buffer[headIndex]
            headIndex = (headIndex + 1) % buffer.count
            _tailIndex += 1
        }
        headIndex = 0
        tailIndex = _tailIndex
        buffer = newBuffer
    }
}

extension DoubleEndedArray: Sequence {
    public struct Iterator: IteratorProtocol {
        var index: Int = 0
        let deque: DoubleEndedArray<Element>

        internal init(deque: DoubleEndedArray<Element>) {
            self.deque = deque
        }

        public mutating func next() -> Element? {
            if index < deque.count {
                defer { index += 1}
                return deque[index]
            }
            return nil
        }
    }
    public func makeIterator() -> Iterator {
        Iterator(deque: self)
    }
}

extension DoubleEndedArray: Collection {
    public var startIndex: Int { 0 }

    public var endIndex: Int { count }

    public func index(after i: Int) -> Int {
        i + 1
    }
}

extension DoubleEndedArray: RandomAccessCollection {}

extension DoubleEndedArray: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    public init(arrayLiteral elements: Element...) {
        self.init()
        self.append(contentsOf: elements)
    }
}