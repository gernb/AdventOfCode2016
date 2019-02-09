//
//  main.swift
//  Day 06
//
//  Created by Bohac, Peter on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Decoder {
    let messages: [String]

    init(with input: String) {
        messages = input.split(separator: "\n").map(String.init)
    }

    func decode() -> String {
        var result = ""

        for index in 0 ..< messages[0].count {
            let values = messages.map { $0.dropFirst(index).first! }
            result += consensusValue(in: values)
        }

        return result
    }

    private func consensusValue(in values: [Character]) -> String {
        let charCount = values.reduce(into: [:]) { dict, char in dict[char] = dict[char, default: 0] + 1 }
        let mostFreqChar = charCount.max { $0.value < $1.value }!.key
        return String(mostFreqChar)
    }
}

let decoder = Decoder(with: InputData.challenge)
print("Decoded:", decoder.decode())

// MARK: Part 2

extension Decoder {
    func decode2() -> String {
        var result = ""

        for index in 0 ..< messages[0].count {
            let values = messages.map { $0.dropFirst(index).first! }
            result += leastCommonValue(in: values)
        }

        return result
    }

    private func leastCommonValue(in values: [Character]) -> String {
        let charCount = values.reduce(into: [:]) { dict, char in dict[char] = dict[char, default: 0] + 1 }
        let leastFreqChar = charCount.min { $0.value < $1.value }!.key
        return String(leastFreqChar)
    }
}

print("Decoded (part 2):", decoder.decode2())
