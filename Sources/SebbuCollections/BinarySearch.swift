//
//  BinarySearch.swift
//  
//
//  Created by Sebastian Toivonen on 11.7.2023.
//

public extension RandomAccessCollection where Element: Comparable {
    // TODO: Is this good?
    func binarySearch(_ element: Element) -> Index? {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if self[mid] < element {
                low = index(after: mid)
            } else if self[mid] > element {
                high = mid
            } else {
                return mid
            }
        }
        return nil
    }
}
