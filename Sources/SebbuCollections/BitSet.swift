//
//  BitSet.swift
//  
//
//  Created by Sebastian Toivonen on 3.8.2023.
//

public struct BitSet {
    private(set) public var size: Int
    
    @usableFromInline
    internal let N = 64
    
    public typealias Word = UInt64
    fileprivate(set) public var words: [Word]
    
    public var cardinality: Int {
        var count = 0
        for var x in words {
            while x != 0 {
                let y = x & ~(x - 1)
                x = y ^ x
                count += 1
            }
        }
        return count
    }
    
    public init(size: Int) {
        precondition(size > 0, "Size has to be more than zero")
        self.size = size
        
        let n = (size + (N - 1)) / N
        words = [Word](repeating: 0, count: n)
    }
    
    @inlinable
    internal func indexOf(_ i: Int) -> (Int, Word) {
        precondition(i >= 0 && i < size, "Index out of bounds")
        let o = i / N
        let m = Word(i - o * N)
        return (o, 1 << m)
    }
    
    @inline(__always)
    public mutating func set(_ i: Int) {
        let (j, m) = indexOf(i)
        words[j] |= m
    }
    
    @inline(__always)
    public mutating func clear(_ i: Int) {
        let (j, m) = indexOf(i)
        words[j] &= ~m
    }
    
    @inline(__always)
    public func isSet(_ i: Int) -> Bool {
        let (j, m) = indexOf(i)
        return (words[j] & m) != 0
    }
    
    @inline(__always)
    public subscript(i: Int) -> Bool {
        get { isSet(i) }
        set { if newValue { set(i) } else { clear(i) } }
    }
}
