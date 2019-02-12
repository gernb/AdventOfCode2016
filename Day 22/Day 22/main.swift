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

let nodes = Node.load(from: InputData.challenge)
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
}

let nodeMap = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
let avgSize = nodes.reduce(0) { $0 + $1.size } / nodes.count

for y in 0 ..< maxY {
    for x in 0 ..< maxX {
        let node = nodeMap["\(x),\(y)"]!
        if y == 0 && x == (maxX - 1) {
            print("G", terminator: "")
        } else if node.used == 0 {
            print("E", terminator: "")
        } else if node.used < avgSize {
            print(".", terminator: "")
        } else {
            print("#", terminator: "")
        }
    }
    print("")
}
