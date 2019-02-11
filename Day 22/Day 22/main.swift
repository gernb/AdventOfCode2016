//
//  main.swift
//  Day 22
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

final class Node {
    let x: Int
    let y: Int

    let size: Int
    var used: Int

    var avail: Int {
        return size - used
    }

    init(string: Substring) {
        let words = string.split(separator: " ")

        let name = words[0].split(separator: "/")[2]
        let pos = name.split(separator: "-")
        self.x = Int(String(pos[1].dropFirst()))!
        self.y = Int(String(pos[2].dropFirst()))!

        assert(words[1].hasSuffix("T"))
        self.size = Int(String(words[1].dropLast()))!

        assert(words[2].hasSuffix("T"))
        self.used = Int(String(words[2].dropLast()))!
    }

    static func load(from input: String) -> [Node] {
        return input.split(separator: "\n")
            .dropFirst(2)
            .map(Node.init)
    }
}

extension Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

func getViablePairs(in nodes: [Node]) -> [(a: Node, b: Node)] {
    var result: [(Node, Node)] = []
    for (_, nodeA) in nodes.enumerated() {
        guard nodeA.used > 0 else { continue }
        for (_, nodeB) in nodes.enumerated() {
            guard nodeA != nodeB else { continue }
            if nodeA.used <= nodeB.avail {
                result.append((nodeA, nodeB))
            }
        }
    }
    return result
}

let nodes = Node.load(from: InputData.example)
print("Count:", nodes.count)
let maxX = nodes.map { $0.x }.max()! + 1
let maxY = nodes.map { $0.y }.max()! + 1
print("Grid size: \(maxX),\(maxY)")

let pairs = getViablePairs(in: nodes)
print("Pairs:", pairs.count)

// MARK: Part 2

// https://codepen.io/anon/pen/BQEZzK/

extension Node {
    var id: String {
        return "\(x),\(y)"
    }

    var neighborIds: [String] {
        return [
            "\(x + 1),\(y)",
            "\(x - 1),\(y)",
            "\(x),\(y + 1)",
            "\(x),\(y - 1)",
        ]
    }

    var distanceFromOrigin: Int {
        return x + y
    }
}

final class Grid {
    let nodes: [String: Node]
    var goalDataLocation: Node

    init(nodes: [Node]) {
        self.nodes = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
        let maxX = nodes.map { $0.x }.max()! + 1
        self.goalDataLocation = self.nodes["\(maxX),0"]!
    }

    func moveGoalDataToOrigin() -> Int {
        var seen: [Grid: Int] = [:]
        var queue: [Grid: (steps: Int, estimated: Int)] = [self: (0, 0)]

        while let (grid, (steps, _)) = queue.min(by: { $0.value.estimated < $1.value.estimated }) {
            queue.removeValue(forKey: grid)
            if grid.goalDataLocation == nodes["0,0"] {
                return steps
            }

            var nextStates: [Grid] = []

            seen[grid] = steps
        }

        print("No solution available!")
        return -1
    }

    func getConnectedNodes(of node: Node) -> [Node] {
        return node.neighborIds.compactMap { nodes[$0] }
    }

    private func moveData(from source: Node, to destination: Node) {
        assert(destination.avail >= source.used)
        destination.used += source.used
        source.used = 0
        if source == goalDataLocation {
            goalDataLocation = destination
        }
    }
}

extension Grid: Hashable {
    static func == (lhs: Grid, rhs: Grid) -> Bool {
        return lhs.nodes == rhs.nodes && lhs.goalDataLocation == rhs.goalDataLocation
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nodes)
        hasher.combine(goalDataLocation)
    }
}
