//
//  RingBuffer.swift
//  
//
//  Created by Sebastian Toivonen on 10.8.2023.
//

/// A fixed size ring buffer
public struct RingBuffer<Element> {
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
    
    @inlinable
    public var capacity: Int {
        buffer.count - 1
    }
    
    @_transparent
    public var isFull: Bool {
        (tailIndex + 1) % buffer.count == headIndex
    }
    
    @_transparent
    public var isEmpty: Bool {
        tailIndex == headIndex
    }
    
    public init(size: Int) {
        assert(size > 2, "The capacity of a Ringbuffer must be more than two")
        buffer = [Element?](repeating: nil, count: size + 1)
    }

    @inlinable
    public subscript(index: Int) -> Element {
        get {
            assert(index >= 0)
            assert(index < count)
            return buffer[(headIndex + index) % buffer.count]!
        }
        set {
            assert(index >= 0)
            assert(index < count)
            buffer[(headIndex + index) % buffer.count] = newValue
        }
    }

    /// Appending an element is an amortized O(1) operation
    /// - returns: Boolean value indicating whether the elements was successfully appended
    @inlinable
    @discardableResult
    public mutating func append(_ element: Element) -> Bool {
        if tailIndex == headIndex || (tailIndex + 1) % buffer.count != headIndex {
            buffer[tailIndex] = element
            tailIndex = (tailIndex + 1) % buffer.count
            return true
        }
        return false
    }

    /// Appends a sequence of elements. If the ring buffer doesn't have enough space to append all the elements, only the first ones that fit into the buffer will be appended
    /// Appending a sequence of elements is a O(*n*) operation where *n* is the amount elements in the sequence
    /// - returns: The number of elements that were successfully appended
    @inlinable
    @discardableResult
    public mutating func append<S: Sequence>(contentsOf: S) -> Int where S.Element == Element {
        var successfulAppends = 0
        for element in contentsOf {
            if !append(element) { break }
            successfulAppends += 1
        }
        return successfulAppends
    }

    /// Prepending an  element is an amortized O(1) operation
    /// - returns: Boolean value indicating whether the elements was successfully prepended
    @inlinable
    @discardableResult
    public mutating func prepend(_ element: Element) -> Bool {
        if headIndex == tailIndex || (headIndex + buffer.count - 1) % buffer.count != tailIndex {
            headIndex = (headIndex + buffer.count - 1) % buffer.count
            buffer[headIndex] = element
            return true
        }
        return false
    }

    /// Prepends a sequence of elements. If the ring buffer doesn't have enough space to prepend all the elements, only the first ones that fit into the buffer will be prepended
    /// Prepending a sequence of elements is a O(*n*) operation where *n* is the amount elements in the sequence
    /// - returns: The number of elements that were successfully prepended
    @inlinable
    @discardableResult
    public mutating func prepend<S: Sequence>(contentsOf: S) -> Int where S.Element == Element {
        var successfulPrepends = 0
        for element in contentsOf {
            if !prepend(element) { break }
            successfulPrepends += 1
        }
        return successfulPrepends
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

    /// Creates a new resized buffer with the elements copied. If the new size is less than the current size
    /// then only the first `newSize` elements will be copied to the new buffer
    /// - returns: A new `Ringbuffer` with the specified size and copied elements
    @inlinable
    public mutating func resized(_ newSize: Int) -> RingBuffer<Element> {
        var newBuffer = RingBuffer<Element>(size: newSize)
        for i in 0..<count {
            newBuffer.append(self[i])
        }
        return newBuffer
    }
    
    @inlinable
    public mutating func resize(_ newSize: Int) {
        self = resized(newSize)
    }
    
    /// Reserve a minimum amount of capacity
    @inlinable
    public mutating func reserveCapacity(_ newCapacity: Int) {
        if buffer.count >= newCapacity { return }
        _grow(newCapacity: newCapacity)
    }

    @inlinable
    public mutating func removeAll(resizingTo: Int = 0) {
        for i in 0..<buffer.count {
            buffer[i] = nil
        }
        if resizingTo > 0 {
            self = resized(resizingTo)
            return
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

extension RingBuffer: Sequence {
    public struct Iterator: IteratorProtocol {
        var index: Int = 0
        let buffer: RingBuffer<Element>

        internal init(deque: RingBuffer<Element>) {
            self.buffer = deque
        }

        public mutating func next() -> Element? {
            if index < buffer.count {
                defer { index += 1}
                return buffer[index]
            }
            return nil
        }
    }
    public func makeIterator() -> Iterator {
        Iterator(deque: self)
    }
}

extension RingBuffer: Collection {
    public var startIndex: Int { 0 }

    public var endIndex: Int { count }

    public func index(after i: Int) -> Int {
        i + 1
    }
}

extension RingBuffer: RandomAccessCollection {}
