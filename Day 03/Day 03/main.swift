//
//  main.swift
//  Day 03
//
//  Created by Peter Bohac on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Triangle {
    let sides: [Int]

    var isValid: Bool {
        return (sides[0] + sides[1] > sides[2]) &&
            (sides[0] + sides[2] > sides[1]) &&
            (sides[1] + sides[2] > sides[0])
    }
}

extension Triangle {
    init(with string: Substring) {
        sides = string.split(separator: " ").map { Int(String($0))! }
    }

    static func load(from input: String) -> [Triangle] {
        return input.split(separator: "\n").map(Triangle.init)
    }
}

let triangles = Triangle.load(from: InputData.challenge)
print("Count:", triangles.count)
print("Valid:", triangles.filter { $0.isValid }.count)

// MARK: Part 2

extension Triangle {
    static func loadVertically(from input: String) -> [Triangle] {
        var triangles: [Triangle] = []
        let lines = input.split(separator: "\n")
        assert(lines.count % 3 == 0)

        for y in stride(from: 0, to: lines.count, by: 3) {
            let rows = lines.dropFirst(y).prefix(3)
                .map { row in row.split(separator: " ").map { Int(String($0))! } }
            for x in 0 ..< 3 {
                let triangle = Triangle(sides: [rows[0][x], rows[1][x], rows[2][x]])
                triangles.append(triangle)
            }
        }

        return triangles
    }
}

let triangles2 = Triangle.loadVertically(from: InputData.challenge)
print("Count:", triangles2.count)
print("Valid:", triangles2.filter { $0.isValid }.count)
