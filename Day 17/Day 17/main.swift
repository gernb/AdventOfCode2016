//
//  main.swift
//  Day 17
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

import CommonCrypto
import Foundation

extension UInt8 {
    var hexString: String {
        let upperNibble = (self >> 4) & 0xF
        let lowerNibble = self & 0xF
        let chars = [ upperNibble, lowerNibble ].map { nibble -> String in
            switch nibble {
            case 0: return "0"
            case 1: return "1"
            case 2: return "2"
            case 3: return "3"
            case 4: return "4"
            case 5: return "5"
            case 6: return "6"
            case 7: return "7"
            case 8: return "8"
            case 9: return "9"
            case 10: return "a"
            case 11: return "b"
            case 12: return "c"
            case 13: return "d"
            case 14: return "e"
            case 15: return "f"
            default: preconditionFailure()
            }
        }
        return chars[0] + chars[1]
    }
}

extension String {
    var md5: String {
        let messageData = self.data(using: .utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }

        let result = digestData.map { $0.hexString }.joined()
        assert(result.count == 32)
        return result
    }
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
    let id: String

    var up: Coordinate { return Coordinate(x: x, y: y - 1, id: id + "U") }
    var down: Coordinate { return Coordinate(x: x, y: y + 1, id: id + "D") }
    var left: Coordinate { return Coordinate(x: x - 1, y: y, id: id + "L") }
    var right: Coordinate { return Coordinate(x: x + 1, y: y, id: id + "R") }

    var neighbors: [(direction: String, room: Coordinate)] {
        return [("U", up), ("D", down), ("L", left), ("R", right)]
    }

    var isRoom: Bool {
        return x >= 0 && x < 4 && y >= 0 && y < 4
    }

    var isVault: Bool {
        return x == 3 && y == 3
    }

    var unlockedDoors: [(direction: String, room: Coordinate)] {
        let hash = Array(id.md5.prefix(4))
        var result: [(direction: String, room: Coordinate)] = []
        for (i, char) in hash.enumerated() {
            guard neighbors[i].room.isRoom else { continue }
            switch char {
            case "b", "c", "d", "e", "f": result.append(neighbors[i])
            default: break
            }
        }
        return result
    }
}

func findShortestPath(from start: Coordinate) -> String {
    var queue: [(room: Coordinate, path: String)] = [(start, "")]

    while queue.isEmpty == false {
        let (room, path) = queue.removeFirst()
        if room.isVault {
            return path
        }

        let nextSteps = room.unlockedDoors
        nextSteps.forEach { direction, nextRoom in
            let newPath = path + direction
            queue.append((nextRoom, newPath))
        }
    }

    print("Unreachable!")
    return ""
}

assert(findShortestPath(from: Coordinate(x: 0, y: 0, id: "ihgpwlah")) == "DDRRRD")
assert(findShortestPath(from: Coordinate(x: 0, y: 0, id: "kglvqrro")) == "DDUDRLRRUDRD")
assert(findShortestPath(from: Coordinate(x: 0, y: 0, id: "ulqzkmiv")) == "DRURDRUDDLLDLUURRDULRLDUUDDDRR")

print(findShortestPath(from: Coordinate(x: 0, y: 0, id: "mmsxrhfx")))

// MARK: Part 2

func findAllPaths(from start: Coordinate) -> [String] {
    var queue: [(room: Coordinate, path: String)] = [(start, "")]
    var result: [String] = []

    while queue.isEmpty == false {
        let (room, path) = queue.removeFirst()
        if room.isVault {
            result.append(path)
            continue
        }

        let nextSteps = room.unlockedDoors
        nextSteps.forEach { direction, nextRoom in
            let newPath = path + direction
            queue.append((nextRoom, newPath))
        }
    }

    return result.sorted { $0.count < $1.count }
}

//var paths = findAllPaths(from: Coordinate(x: 0, y: 0, id: "ihgpwlah"))
//assert(paths.last!.count == 370)
//paths = findAllPaths(from: Coordinate(x: 0, y: 0, id: "kglvqrro"))
//assert(paths.last!.count == 492)
//paths = findAllPaths(from: Coordinate(x: 0, y: 0, id: "ulqzkmiv"))
//assert(paths.last!.count == 830)

let paths = findAllPaths(from: Coordinate(x: 0, y: 0, id: "mmsxrhfx"))
print("Longest path:", paths.last!.count)
