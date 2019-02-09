//
//  main.swift
//  Day 09
//
//  Created by Peter Bohac on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

func decompress(_ string: String) -> String {
    enum State {
        case normal
        case parsingMarker
        case parsingData(len: Int, repeat: Int)
    }

    // easier to work with an array
    var result: [Character] = []
    var state = State.normal
    var substring: [Character] = []
    var count = 0

    string.forEach { char in
        switch (state, char) {
        case (.normal, "("):
            substring = []
            state = .parsingMarker
        case (.normal, _):
            result.append(char)

        case (.parsingMarker, ")"):
            let values = String(substring).split(separator: "x").map { Int(String($0))! }
            substring = []
            count = 0
            state = .parsingData(len: values[0], repeat: values[1])
        case (.parsingMarker, _):
            substring.append(char)

        case (.parsingData(let len, let repeatCount), _):
            substring.append(char)
            count += 1
            if count == len {
                for _ in 0 ..< repeatCount {
                    result += substring
                }
                state = .normal
            }
        }
    }

    return String(result)
}

print(decompress(InputData.challenge).count)
print("")

// MARK: Part 2

func getDecompressedLen(_ string: String) -> Int {
    return getDecompressedLen(Array(string))
}

func getDecompressedLen(_ chars: [Character]) -> Int {
    enum State {
        case normal
        case parsingMarker
        case parsingData(len: Int, repeat: Int)
    }

    var len = 0
    var state = State.normal
    var substring: [Character] = []
    var count = 0

    chars.forEach { char in
        switch (state, char) {
        case (.normal, "("):
            substring = []
            state = .parsingMarker
        case (.normal, _):
            len += 1

        case (.parsingMarker, ")"):
            let values = String(substring).split(separator: "x").map { Int(String($0))! }
            substring = []
            count = 0
            state = .parsingData(len: values[0], repeat: values[1])
        case (.parsingMarker, _):
            substring.append(char)

        case (.parsingData(let dataLen, let repeatCount), _):
            substring.append(char)
            count += 1
            if count == dataLen {
                len += getDecompressedLen(substring) * repeatCount
                state = .normal
            }
        }
    }

    return len
}

let len = getDecompressedLen(InputData.challenge)
print(len)
print("")
