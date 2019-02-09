//
//  main.swift
//  Day 07
//
//  Created by Bohac, Peter on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

import Foundation

struct IPv7Address {
    let rawValue: String
    let hypernetSequences: [String]
    let plainSequences: [String]

    var supportsTLS: Bool {
        let plainContainsABBA = plainSequences.map { containsABBA($0) }.reduce(false) { $0 || $1 }
        let hypernetContainsABBA = hypernetSequences.map { containsABBA($0) }.reduce(false) { $0 || $1 }
        return plainContainsABBA && !hypernetContainsABBA
    }

    init(rawValue: String) {
        self.rawValue = rawValue

        let hypernetRegex = try! NSRegularExpression(pattern: "\\[.*?\\]")

        let matches = hypernetRegex.matches(in: rawValue, range: NSRange(rawValue.startIndex..., in: rawValue))
        self.hypernetSequences = matches.map { match in
            let range = Range(match.range, in: rawValue)!
            return String(rawValue[range])
        }

        let text = NSMutableString(string: rawValue)
        hypernetRegex.replaceMatches(in: text, range: NSRange(rawValue.startIndex..., in: rawValue), withTemplate: "/")
        self.plainSequences = (text as String).split(separator: "/").map(String.init)
    }

    private func containsABBA(_ string: String) -> Bool {
        guard string.count >= 4 else { return false }
        // easier to work with arrays
        let chars = Array(string)
        var previous = chars[1]
        for i in 2 ..< (chars.count - 1) {
            if chars[i] == previous && chars[i - 2] == chars[i + 1] && chars[i] != chars[i + 1] {
                return true
            }
            previous = chars[i]
        }
        return false
    }
}

let addresses = InputData.challenge.map(IPv7Address.init)
print("Total count:", addresses.count)

let addressesSupportingTLS = addresses.filter { $0.supportsTLS }
print("TLS Supported count:", addressesSupportingTLS.count)

// MARK: Part 2

extension IPv7Address {
    var supportsSSL: Bool {
        let abaSet = plainSequences.map { getABASequences(for: $0) }
            .reduce(Set<String>()) { result, set in result.union(set) }
        for aba in Array(abaSet) {
            let bab = getBAB(from: aba)
            for hypernet in hypernetSequences {
                if hypernet.contains(bab) {
                    return true
                }
            }
        }
        return false
    }

    private func getABASequences(for string: String) -> Set<String> {
        var result = Set<String>()
        guard string.count >= 3 else { return result }
        // easier to work with arrays
        let chars = Array(string)
        for i in 0 ..< (chars.count - 2) {
            if chars[i] == chars[i + 2] && chars[i] != chars[i + 1] {
                result.insert(String(chars[i]) + String(chars[i + 1]) + String(chars[i + 2]))
            }
        }
        return result
    }

    private func getBAB(from aba: String) -> String {
        let chars = Array(aba)
        return String(chars[1]) + String(chars[0]) + String(chars[1])
    }
}

let addressesSupportingSSL = addresses.filter { $0.supportsSSL }
print("SSL Supported count:", addressesSupportingSSL.count)
