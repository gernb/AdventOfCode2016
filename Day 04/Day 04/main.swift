//
//  main.swift
//  Day 04
//
//  Created by Bohac, Peter on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Room {
    let nameParts: [String]
    let sectorID: Int
    let providedChecksum: String

    var encryptedName: String {
        return nameParts.joined(separator: "-")
    }

    var isReal: Bool {
        return providedChecksum == checksum
    }

    var checksum: String {
        var charCount: [Character: Int] = [:]
        nameParts.joined().forEach { char in charCount[char] = charCount[char, default: 0] + 1 }
        let sortedChars = charCount.sorted { lhs, rhs in
            if lhs.value == rhs.value {
                return lhs.key < rhs.key
            } else {
                return lhs.value > rhs.value
            }
        }
        return sortedChars.prefix(5).map { String($0.key) }.joined()
    }
}

extension Room: CustomStringConvertible {
    var description: String {
        return "\(encryptedName)-\(sectorID)[\(checksum)]"
    }
}

extension Room {
    private init(with string: Substring) {
        let parts = string.split(separator: "-")
        let idAndChecksum = parts.last!.split(separator: "[")
        let nameParts = parts.dropLast().map(String.init)
        let sectorID = Int(String(idAndChecksum[0]))!
        let checksum = String(idAndChecksum[1].dropLast())
        self.init(nameParts: nameParts, sectorID: sectorID, providedChecksum: checksum)
    }

    static func load(from input: String) -> [Room] {
        return input.split(separator: "\n").map(Room.init)
    }
}

let rooms = Room.load(from: InputData.challenge)
print("Count:", rooms.count)

let realRooms = rooms.filter { $0.isReal }
let sum = realRooms.reduce(0) { $0 + $1.sectorID }
print("Sector IDs sum:", sum)

// MARK: Part 2

extension Room {
    static var alphabet: [Character] = {
        let valueOfA = Int(("a" as UnicodeScalar).value)
        return (0 ..< 26).map { Character(UnicodeScalar(valueOfA + $0)!) }
    }()

    var decryptedName: String {
        let decryptedParts = nameParts.map { name -> String in
            return name.map { char in
                let index = Room.alphabet.firstIndex(of: char)!
                return String(Room.alphabet[(index + sectorID) % Room.alphabet.count])
            }.joined()
        }
        return decryptedParts.joined(separator: " ")
    }
}

let northPoleRoom = realRooms.first { $0.decryptedName.hasPrefix("north") }!
print("\(northPoleRoom) -> \(northPoleRoom.decryptedName)")
