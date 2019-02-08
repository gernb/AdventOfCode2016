//
//  main.swift
//  Day 01
//
//  Created by Peter Bohac on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

import Foundation

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    static let origin =  Coordinate(x: 0, y: 0)

    func distance(to other: Coordinate) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

enum Heading {
    case north, south, east, west
}

struct Position {
    var coordinate = Coordinate.origin
    var heading = Heading.north

    mutating func turnRight() {
        switch heading {
        case .north: heading = .east
        case .south: heading = .west
        case .east: heading = .south
        case .west: heading = .north
        }
    }

    mutating func turnLeft() {
        switch heading {
        case .north: heading = .west
        case .south: heading = .east
        case .east: heading = .north
        case .west: heading = .south
        }
    }

    mutating func move(count blocks: Int = 1) {
        switch heading {
        case .north: coordinate = Coordinate(x: coordinate.x, y: coordinate.y - blocks)
        case .south: coordinate = Coordinate(x: coordinate.x, y: coordinate.y + blocks)
        case .east: coordinate = Coordinate(x: coordinate.x + blocks, y: coordinate.y)
        case .west: coordinate = Coordinate(x: coordinate.x - blocks, y: coordinate.y)
        }
    }
}

func follow(instructions: String) {
    var position = Position()
    instructions.split(separator: ",")
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .map { ($0.first!, Int(String($0.dropFirst()))! ) }
        .forEach { turn, blocks in
            switch turn {
            case "R": position.turnRight()
            case "L": position.turnLeft()
            default: preconditionFailure()
            }
            position.move(count: blocks)
        }
    print("Distance from origin:", position.coordinate.distance(to: .origin))
}

follow(instructions: "R2, L3") // => 5
follow(instructions: "R2, R2, R2") // => 2
follow(instructions: "R5, L5, R5, R3") // => 12
follow(instructions: InputData.challenge)

// MARK: Part 2

func visit(instructions: String) {
    var position = Position()
    var visited = Set([position.coordinate])
    let sequence = instructions.split(separator: ",")
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .map { ($0.first!, Int(String($0.dropFirst()))! ) }

    loop: for i in 0 ..< sequence.count {
        let (turn, blocks) = sequence[i]

        switch turn {
        case "R": position.turnRight()
        case "L": position.turnLeft()
        default: preconditionFailure()
        }

        for _ in 0 ..< blocks {
            position.move()
            if visited.contains(position.coordinate) {
                break loop
            } else {
                visited.insert(position.coordinate)
            }
        }
    }

    print("Distance from origin:", position.coordinate.distance(to: .origin))
}

visit(instructions: "R8, R4, R4, R8") // => 4
visit(instructions: InputData.challenge)
