//
//  main.swift
//  Day 24
//
//  Created by Bohac, Peter on 2/11/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    var up: Coordinate { return Coordinate(x: x, y: y - 1) }
    var down: Coordinate { return Coordinate(x: x, y: y + 1) }
    var left: Coordinate { return Coordinate(x: x - 1, y: y) }
    var right: Coordinate { return Coordinate(x: x + 1, y: y) }

    var adjacent: [Coordinate] {
        return [up, down, left, right]
    }
}

final class Node: Hashable {
    let location: Coordinate
    var neighbors: [Node] = []

    init(location: Coordinate) {
        self.location = location
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.location == rhs.location
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
    }
}

struct Maze {
    let nodes: [Coordinate: Node]
    let numbers: [Int: Node]

    init(input: [[Character]]) {
        var nodes: [Coordinate: Node] = [:]
        var numbers: [Int: Node] = [:]

        for (y, row) in input.enumerated() {
            for (x, char) in row.enumerated() {
                guard char != "#" else { continue }
                let location = Coordinate(x: x, y: y)
                let node = nodes[location] ?? Node(location: location)
                let adjacent = location.adjacent.compactMap { input[$0.y][$0.x] != "#" ? $0 : nil }
                let neighbors = adjacent.map { coord -> Node in
                    let nodeAtCoord = nodes[coord] ?? Node(location: coord)
                    nodes[coord] = nodeAtCoord
                    return nodeAtCoord
                }
                node.neighbors = neighbors
                nodes[location] = node
                if let num = Int(String(char)) {
                    numbers[num] = node
                }
            }
        }
        self.nodes = nodes
        self.numbers = numbers
    }

    func findDistance(from start: Node, to target: Node) -> Int {
        var visited: [Node: Int] = [:]
        var queue: [(node: Node, steps: Int)] = [(start, 0)]

        while queue.isEmpty == false {
            let (node, steps) = queue.removeFirst()
            if node == target {
                return steps
            }
            let nextNodes = node.neighbors
            let nextSteps = steps + 1
            nextNodes.forEach { nextNode in
                if let previousCount = visited[nextNode], previousCount <= nextSteps {
                    return
                }
                if queue.contains(where: { $0.node == nextNode }) {
                    return
                }
                queue.append((nextNode, nextSteps))
            }
            visited[node] = steps
        }

        preconditionFailure("No path to target!")
    }

    func visitAllNumbers() -> Int {
        var stepCount = 0
        var currentNumber = 0
        var remainingNumbers = numbers
        remainingNumbers.removeValue(forKey: currentNumber)

        while remainingNumbers.isEmpty == false {
            let startNode = numbers[currentNumber]!
            // find the distance to all remaining numbers
            let distances = remainingNumbers.map { pair -> (number: Int, distance: Int) in
                let distance = findDistance(from: startNode, to: pair.value)
                return (pair.key, distance)
            }
            let closest = distances.min { $0.distance < $1.distance }!

            // "move" to the closest and repeat
            stepCount += closest.distance
            currentNumber = closest.number
            remainingNumbers.removeValue(forKey: currentNumber)
        }

        return stepCount
    }
}

let maze = Maze(input: InputData.challenge)

let totalSteps = maze.visitAllNumbers()
print("Total step count:", totalSteps)

// MARK: Part 2

extension Array where Element: Equatable {
    var permutations: [[Element]] {
        guard self.count > 1 else { return [self] }
        return self.flatMap { element in
            return self.removing(element).permutations.map { [element] + $0 }
        }
    }

    func removing(_ element: Element) -> [Element] {
        guard let index = firstIndex(where: { $0 == element }) else { return self }
        var result = self
        result.remove(at: index)
        return result
    }
}

struct Pair: Hashable {
    let a: Int
    let b: Int

    init(a: Int, b: Int) {
        self.a = min(a, b)
        self.b = max(a, b)
    }
}

extension Maze {
    func findDistancesBetweenAllNumbers() -> [Pair: Int] {
        var result: [Pair: Int] = [:]
        let count = numbers.keys.count

        for a in 0 ..< (count - 1) {
            for b in (a + 1) ..< count {
                let nodeA = numbers[a]!
                let nodeB = numbers[b]!
                let distance = findDistance(from: nodeA, to: nodeB)
                let pair = Pair(a: a, b: b)
                result[pair] = distance
            }
        }

        return result
    }

    func findShortestDistance() -> Int {
        // generate all permutations
        let count = numbers.keys.count
        let solutions = Array(1 ..< count).permutations
            .map { [0] + $0 + [0] }
            .map { solution in solution.dropLast().enumerated().map { i, elem in (elem, solution[i + 1]) } }

        let segmentDistances = findDistancesBetweenAllNumbers()
        let distances = solutions.map { solution in
            solution.reduce(0) { sum, segment in
                let pair = Pair(a: segment.0, b: segment.1)
                return sum + segmentDistances[pair]!
            }
        }
        return distances.min()!
    }
}

print("Total step count with return to 0:", maze.findShortestDistance())
print("")
