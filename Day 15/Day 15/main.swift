//
//  main.swift
//  Day 15
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Disc {
    let id: Int
    let positions: Int
    let offset: Int
}

// example
//let discs = [
//    Disc(id: 1, positions: 5, offset: 4),
//    Disc(id: 2, positions: 2, offset: 1),
//]

// challenge
let discs = [
    Disc(id: 1, positions: 17, offset: 1),
    Disc(id: 2, positions: 7, offset: 0),
    Disc(id: 3, positions: 19, offset: 2),
    Disc(id: 4, positions: 5, offset: 0),
    Disc(id: 5, positions: 3, offset: 0),
    Disc(id: 6, positions: 13, offset: 5),
    // part 2
    Disc(id: 7, positions: 11, offset: 0),
]

func partOneSolution(with discs: [Disc]) {
    var time = 0

    repeat {
        let slots = discs.map { disc in
            return (time + disc.id + disc.offset) % disc.positions
        }
        if slots.reduce(0, +) == 0 {
            break
        }
        time += 1
    } while true

    print("Press button at:", time)
}

partOneSolution(with: discs)
