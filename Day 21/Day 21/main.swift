//
//  main.swift
//  Day 21
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

enum Instruction {
    case swapPositions(Int, Int)
    case swapLetters(Character, Character)
    case rotate(Int)
    case rotateLetter(Character)
    case reverse(Int, Int)
    case move(Int, Int)

    func execute(on string: inout [Character]) {
        switch self {
        case .swapPositions(let x, let y):
            string.swapAt(x, y)

        case .swapLetters(let x, let y):
            let idxX = string.firstIndex(of: x)!
            let idxY = string.firstIndex(of: y)!
            string.swapAt(idxX, idxY)

        case .rotate(var count):
            if count < 0 {
                count = string.count + count
            }
            count = count % string.count
            let head = string[(string.count - count)...]
            let tail = string.prefix(string.count - count)
            string = Array(head + tail)

        case .rotateLetter(let x):
            let idxX = string.firstIndex(of: x)!
            let count = 1 + idxX + (idxX >= 4 ? 1 : 0)
            Instruction.rotate(count).execute(on: &string)

        case .reverse(let x, let y):
            let span = string.dropFirst(x).prefix(y - x + 1).reversed()
            string = Array(string.prefix(x)) + Array(span) + Array(string.dropFirst(x + span.count))

        case .move(let x, let y):
            let char = string.remove(at: x)
            string.insert(char, at: y)
        }
    }
}

extension Instruction {
    private init(string: Substring) {
        let words = string.split(separator: " ").map(String.init)
        switch (words[0], words[1]) {
        case ("swap", "position"):
            let x = Int(words[2])!
            let y = Int(words[5])!
            self = .swapPositions(x, y)

        case ("swap", "letter"):
            let x = words[2].first!
            let y = words[5].first!
            self = .swapLetters(x, y)

        case ("rotate", "left"):
            let x = -Int(words[2])!
            self = .rotate(x)

        case ("rotate", "right"):
            let x = Int(words[2])!
            self = .rotate(x)

        case ("rotate", "based"):
            let x = words.last!.last!
            self = .rotateLetter(x)

        case ("reverse", _):
            let x = Int(words[2])!
            let y = Int(words[4])!
            self = .reverse(x, y)

        case ("move", _):
            let x = Int(words[2])!
            let y = Int(words[5])!
            self = .move(x, y)

        default:
            preconditionFailure()
        }
    }

    static func load(from input: String) -> [Instruction] {
        return input.split(separator: "\n").map(Instruction.init)
    }
}

let instructions = Instruction.load(from: InputData.challenge)
var password = Array("abcdefgh")

instructions.forEach {
    $0.execute(on: &password)
}
print("Scrambled password:", String(password))

// MARK: Part 2

extension Instruction {
    func executeInverse(on string: inout [Character]) {
        switch self {
        case .swapPositions(let x, let y):
            string.swapAt(x, y)

        case .swapLetters(let x, let y):
            let idxX = string.firstIndex(of: x)!
            let idxY = string.firstIndex(of: y)!
            string.swapAt(idxX, idxY)

        case .rotate(var count):
            count = -count
            if count < 0 {
                count = string.count + count
            }
            count = count % string.count
            let head = string[(string.count - count)...]
            let tail = string.prefix(string.count - count)
            string = Array(head + tail)

        case .rotateLetter(let x):
            let count: Int = {
                let idx = string.firstIndex(of: x)!
                switch idx {
                case 1: return -1
                case 3: return -2
                case 5: return -3
                case 7: return -4
                case 2: return 2
                case 4: return 1
                case 6: return 0
                case 0: return 7
                default: preconditionFailure()
                }
            }()
            Instruction.rotate(count).execute(on: &string)

        case .reverse(let x, let y):
            let span = string.dropFirst(x).prefix(y - x + 1).reversed()
            string = Array(string.prefix(x)) + Array(span) + Array(string.dropFirst(x + span.count))

        case .move(let x, let y):
            let char = string.remove(at: y)
            string.insert(char, at: x)
        }
    }
}

var scrambled = Array("fbgdceah")

instructions.reversed().forEach {
    $0.executeInverse(on: &scrambled)
}
print("Original password:", String(scrambled))
