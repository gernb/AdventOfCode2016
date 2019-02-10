//
//  main.swift
//  Day 13
//
//  Created by Peter Bohac on 2/9/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    var up: Coordinate { return Coordinate(x: x, y: y - 1) }
    var down: Coordinate { return Coordinate(x: x, y: y + 1) }
    var left: Coordinate { return Coordinate(x: x - 1, y: y) }
    var right: Coordinate { return Coordinate(x: x + 1, y: y) }

    var neighbors: [Coordinate] {
        return [up, down, left, right]
    }

    var isOpen: Bool {
        guard x >= 0 && y >= 0 else { return false }
        let value = (x * x) + (3 * x) + (2 * x * y) + y + (y * y) + 1364
        let bitCount = value.nonzeroBitCount
        return bitCount % 2 == 0
    }

    func distance(to other: Coordinate) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

func findShortestPath(from start: Coordinate, to target: Coordinate) -> Int {
    var visited: [Coordinate: Int] = [:]
    var queue: [Coordinate: (steps: Int, estimated: Int)] = [start: (0, 0)]

    while let (location, (steps, _)) = queue.min(by: { $0.value.estimated < $1.value.estimated }) {
        queue.removeValue(forKey: location)
        if (location == target) {
            return steps
        }

        let nextLocations = location.neighbors.filter { $0.isOpen }
        let nextSteps = steps + 1
        nextLocations.forEach { nextLocation in
            if let previousSteps = visited[nextLocation], previousSteps <= nextSteps {
                return
            }
            if let queued = queue[nextLocation], queued.steps <= nextSteps {
                return
            }
            queue[nextLocation] = (nextSteps, nextLocation.distance(to: target))
        }

        visited[location] = steps
    }
    preconditionFailure()
}

let count = findShortestPath(from: Coordinate(x: 1, y: 1), to: Coordinate(x: 31, y: 39))
print("Steps:", count)

// MARK: Part 2

func findLocationsReachable(from start: Coordinate, maxSteps: Int) -> Int {
    var visited: [Coordinate: Int] = [:]
    var queue: [(location: Coordinate, steps: Int)] = [(start, 0)]

    while queue.isEmpty == false {
        let (location, steps) = queue.removeFirst()

        let nextSteps = steps + 1
        guard steps <= maxSteps else { continue }

        let nextLocations = location.neighbors.filter { $0.isOpen }
        nextLocations.forEach { nextLocation in
            if let previousSteps = visited[nextLocation], previousSteps <= nextSteps {
                return
            }
            if let index = queue.firstIndex(where: { $0.location == nextLocation }) {
                let queued = queue[index]
                if nextSteps < queued.steps {
                    queue[index] = (nextLocation, nextSteps)
                }
                return
            }
            queue.append((nextLocation, nextSteps))
        }

        visited[location] = steps
    }

    return visited.keys.count
}

let reachable = findLocationsReachable(from: Coordinate(x: 1, y: 1), maxSteps: 50)
print("Locations:", reachable)
