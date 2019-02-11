//
//  main.swift
//  Day 20
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

let ranges = InputData.challenge
    .sorted { $0[0] < $1[0] }
    .map { $0[0] ... $0[1] }

let mergedRanges: [ClosedRange<Int>] = {
    var result: [ClosedRange<Int>] = []
    var currentRange = ranges.first!

    for (_, range) in ranges.dropFirst().enumerated() {
        if currentRange.contains(range.lowerBound) || (currentRange.upperBound + 1) == range.lowerBound {
            currentRange = currentRange.lowerBound ... max(currentRange.upperBound, range.upperBound)
        } else {
            result.append(currentRange)
            currentRange = range
        }
    }
    result.append(currentRange)

    return result
}()

print("Lowest unblocked IP:", mergedRanges.first!.upperBound + 1)

let unblockedCount = mergedRanges.reduce((0...4294967295).count) { $0 - $1.count }
print("Unblocked IP count:", unblockedCount)
