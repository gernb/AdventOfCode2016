//
//  main.swift
//  Day 02
//
//  Created by Peter Bohac on 2/7/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

final class Keypad {
    // 1 2 3
    // 4 5 6
    // 7 8 9
    var currentKey = 5

    func move(_ direction: Character) {
        switch (currentKey, direction) {
        case (1, "R"): currentKey = 2
        case (1, "D"): currentKey = 4

        case (2, "L"): currentKey = 1
        case (2, "R"): currentKey = 3
        case (2, "D"): currentKey = 5

        case (3, "L"): currentKey = 2
        case (3, "D"): currentKey = 6

        case (4, "U"): currentKey = 1
        case (4, "R"): currentKey = 5
        case (4, "D"): currentKey = 7

        case (5, "U"): currentKey = 2
        case (5, "L"): currentKey = 4
        case (5, "R"): currentKey = 6
        case (5, "D"): currentKey = 8

        case (6, "U"): currentKey = 3
        case (6, "L"): currentKey = 5
        case (6, "D"): currentKey = 9

        case (7, "U"): currentKey = 4
        case (7, "R"): currentKey = 8

        case (8, "L"): currentKey = 7
        case (8, "R"): currentKey = 9
        case (8, "U"): currentKey = 5

        case (9, "L"): currentKey = 8
        case (9, "U"): currentKey = 6

        default:
            break
        }
    }
}

func parse(instructions: String) -> String {
    let pad = Keypad()
    var numbers: [Int] = []
    instructions.split(separator: "\n").forEach { line in
        line.forEach { pad.move($0) }
        numbers.append(pad.currentKey)
    }
    return numbers.map(String.init).joined()
}

print(parse(instructions: InputData.challenge))

// MARK: Part 2

final class FancyKeypad {
    //     1
    //   2 3 4
    // 5 6 7 8 9
    //   A B C
    //     D
    var currentKey = "5"

    func move(_ direction: Character) {
        switch (currentKey, direction) {
        case ("1", "D"): currentKey = "3"

        case ("2", "R"): currentKey = "3"
        case ("2", "D"): currentKey = "6"

        case ("3", "U"): currentKey = "1"
        case ("3", "L"): currentKey = "2"
        case ("3", "R"): currentKey = "4"
        case ("3", "D"): currentKey = "7"

        case ("4", "L"): currentKey = "3"
        case ("4", "D"): currentKey = "8"

        case ("5", "R"): currentKey = "6"

        case ("6", "U"): currentKey = "2"
        case ("6", "L"): currentKey = "5"
        case ("6", "R"): currentKey = "7"
        case ("6", "D"): currentKey = "A"

        case ("7", "U"): currentKey = "3"
        case ("7", "L"): currentKey = "6"
        case ("7", "R"): currentKey = "8"
        case ("7", "D"): currentKey = "B"

        case ("8", "U"): currentKey = "4"
        case ("8", "L"): currentKey = "7"
        case ("8", "R"): currentKey = "9"
        case ("8", "D"): currentKey = "C"

        case ("9", "L"): currentKey = "8"

        case ("A", "U"): currentKey = "6"
        case ("A", "R"): currentKey = "B"

        case ("B", "U"): currentKey = "7"
        case ("B", "L"): currentKey = "A"
        case ("B", "R"): currentKey = "C"
        case ("B", "D"): currentKey = "D"

        case ("C", "U"): currentKey = "8"
        case ("C", "L"): currentKey = "B"

        case ("D", "U"): currentKey = "B"

        default:
            break
        }
    }
}

func parse2(instructions: String) -> String {
    let pad = FancyKeypad()
    var keys: [String] = []
    instructions.split(separator: "\n").forEach { line in
        line.forEach { pad.move($0) }
        keys.append(pad.currentKey)
    }
    return keys.joined()
}

print(parse2(instructions: InputData.challenge))
