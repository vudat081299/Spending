//
//  SearchEngine.swift
//  Spending
//
//  Created by Dat Vu on 05/01/2023.
//

import Foundation

class SearchEngine {
    /// search with payment list have dateTime sorted in inverse order
    static func binarySearch(in list: [Payment], for payment: Payment) -> Int {
        var left = 0
        var right = list.count - 1
        while left <= right {
            let middle = Int(floor(Double(left + right) / 2.0))
            if list[middle] > payment {
                left = middle + 1
            } else if list[middle] < payment {
                right = middle - 1
            } else {
                return middle
            }
        }
        return 0
    }
}


