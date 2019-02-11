//
//  main.swift
//  Day 16
//
//  Created by Peter Bohac on 2/10/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

func generateData(start: String, length: Int) -> String {
    var result = start

    while result.count < length {
        let b = result.reversed().map { $0 == "1" ? "0" : "1" }
        result = result + "0" + b.joined()
    }

    return String(result.prefix(length))
}

func getChecksum(for data: String) -> String {
    var checksum = data

    while checksum.count % 2 == 0 {
        var newChecksum = ""
        for i in stride(from: 0, to: checksum.count, by: 2) {
            let chars = checksum.dropFirst(i).prefix(2)
            switch chars {
            case "00", "11": newChecksum += "1"
            case "01", "10": newChecksum += "0"
            default: preconditionFailure()
            }
        }
        checksum = newChecksum
    }

    return checksum
}

// example
var data = generateData(start: "10000", length: 20)
var checksum = getChecksum(for: data)
print("Checksum for example:", checksum)

// challenge, part 1
data = generateData(start: "11100010111110100", length: 272)
checksum = getChecksum(for: data)
print("Checksum for challenge:", checksum)

// challenge, part 2
func getChecksum2(for data: String) -> String {
    var checksum = Array(data)

    while checksum.count % 2 == 0 {
        var newChecksum: [Character] = []
        for i in stride(from: 0, to: checksum.count, by: 2) {
            let chars = [checksum[i], checksum[i + 1]]
            switch chars {
            case ["0", "0"], ["1", "1"]: newChecksum += ["1"]
            case ["1", "0"], ["0", "1"]: newChecksum += ["0"]
            default: preconditionFailure()
            }
        }
        checksum = newChecksum
    }

    return String(checksum)
}

data = generateData(start: "11100010111110100", length: 35651584)
checksum = getChecksum2(for: data)
print("Checksum for part 2:", checksum)
