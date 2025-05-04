//
//  Array+OptimizedMap.swift
//  sebbu-collections
//
//  Created by Sebastian Toivonen on 5.4.2025.
//

public extension Array {
    @inlinable
    func betterMap<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
        try [T](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            for i in 0..<count {
                try buffer.initializeElement(at: i, to: transform(self[i]))
            }
            initializedCount = count
        }
    }
}
