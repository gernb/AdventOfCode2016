//
//  main.swift
//  Day 18
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Room {
    var tiles: [[Int]] // 1 is safe, 0 is trap

    init(firstRow: String) {
        let row = firstRow.map { $0 == "." ? 1 : 0 }
        self.tiles = [row]
    }

    mutating func safeTiles(rows: Int) -> Int {
        while tiles.count < rows {
            addRow()
        }
        return tiles.prefix(rows).flatMap { $0 }.reduce(0, +)
    }

    private mutating func addRow() {
        let previousRow = [1] + tiles.last! + [1]
        var newRow = Array(repeating: 0, count: previousRow.count - 2)
        for i in 1 ... newRow.count {
            let left = previousRow[i - 1]
            let center = previousRow[i]
            let right = previousRow[i + 1]
            newRow[i - 1] = {
                switch (left, center, right) {
                case (0, 0, 1): return 0
                case (1, 0, 0): return 0
                case (0, 1, 1): return 0
                case (1, 1, 0): return 0
                default: return 1
                }
            }()
        }
        tiles.append(newRow)
    }
}

var room = Room(firstRow: InputData.example1)
assert(room.safeTiles(rows: 3) == 6)
room = Room(firstRow: InputData.example2)
assert(room.safeTiles(rows: 10) == 38)

room = Room(firstRow: InputData.challenge)
print("Safe tiles in room (40 rows):", room.safeTiles(rows: 40))

print("Safe tiles in room (400,000 rows):", room.safeTiles(rows: 400_000))
