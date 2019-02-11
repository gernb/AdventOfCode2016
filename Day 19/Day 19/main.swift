//
//  main.swift
//  Day 19
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

func lastElf(count: Int) -> Int {
    var elves = Array(1 ... count)
    while elves.count > 1 {
        if elves.count % 2 == 1 {
            elves[0] = 0
        }
        for i in stride(from: 1, to: elves.count, by: 2) {
            elves[i] = 0
        }
        elves = elves.filter { $0 > 0 }
    }
    return elves.first!
}

print("Last elf:", lastElf(count: 3004953))

// MARK: Part 2

func lastElf2(count: Int) -> Int {
    var elves = Array(1 ... count)
    var index = 0
    while elves.count > 1 {
        let stealFromElfAtIndex = (index + (elves.count / 2)) % elves.count
        elves.remove(at: stealFromElfAtIndex)
        if stealFromElfAtIndex < index {
            index -= 1
        }
        index = (index + 1) % elves.count
    }
    return elves.first!
}

// Too slow :(
//print("Last elf, part 2:", lastElf2(count: 3004953))

final class Elf {
    let id: Int
    var next: Elf!

    init(id: Int, next: Elf? = nil) {
        self.id = id
        self.next = next
    }

    func removeNext() {
        next = next.next
    }
}

func lastElf3(count: Int) -> Int {
    // create elves
    var end: Elf?
    var last: Elf?
    for i in (1 ... count).reversed() {
        let elf = Elf(id: i, next: last)
        if last == nil {
            end = elf
        }
        last = elf
    }
    end?.next = last

    var remainingCount = count
    var current: Elf = last!
    var across = current
    (0 ..< (remainingCount / 2 - 1)).forEach { _ in across = across.next }

    while current.next! !== current {
        across.removeNext()
        remainingCount -= 1
        if remainingCount % 2 == 0 {
            across = across.next
        }
        current = current.next
    }

    return current.id
}

print("Last elf, part 2:", lastElf3(count: 3004953))
