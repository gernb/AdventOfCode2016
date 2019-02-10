//
//  main.swift
//  Day 14
//
//  Created by Peter Bohac on 2/9/19.
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

final class HashNode {
    static var salt = "abc"

    let index: Int
    let hash: String
    let keyStretching: Bool
    let tripletChar: Character?
    lazy var next: HashNode = {
        return HashNode(index: index + 1, keyStretching: keyStretching)
    }()

    init(index: Int, keyStretching: Bool = false) {
        self.index = index
        self.keyStretching = keyStretching
        if keyStretching {
            var hash = "\(HashNode.salt)\(index)".md5
            for _ in 0 ..< 2016 {
                hash = hash.md5
            }
            self.hash = hash
        } else {
            self.hash = "\(HashNode.salt)\(index)".md5
        }
        self.tripletChar = HashNode.findFirstTriplet(in: hash)
    }

    func contains5(of char: Character) -> Bool {
        let substring = String(repeating: char, count: 5)
        return hash.contains(substring)
    }

    private static func findFirstTriplet(in hash: String) -> Character? {
        let chars = Array(hash)
        var lastChar: Character?
        var count = 0

        for i in 0 ..< chars.count {
            if chars[i] == lastChar {
                count += 1
                if count == 3 {
                    return chars[i]
                }
            } else {
                lastChar = chars[i]
                count = 1
            }
        }

        return nil
    }
}

HashNode.salt = "ngcjuoqr"

var keys: [String] = []
var currentNode = HashNode(index: 0, keyStretching: true)
while keys.count < 64 {
    if let char = currentNode.tripletChar {
        var searchNode = currentNode.next
        while searchNode.index <= (currentNode.index + 1000) {
            if searchNode.contains5(of: char) {
                keys.append(currentNode.hash)
                break
            }
            searchNode = searchNode.next
        }
    }
    currentNode = currentNode.next
}

print("Last key found at index:", currentNode.index - 1)
