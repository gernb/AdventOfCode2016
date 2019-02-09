//
//  main.swift
//  Day 05
//
//  Created by Bohac, Peter on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

import CommonCrypto
import Foundation

extension String {
    var md5: String {
        let messageData = self.data(using: .utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }

        return digestData.map { String(format: "%02x", $0) }.joined()
    }
}

func findPassword(for door: String) -> String {
    var password = ""
    var index = 0

    while password.count < 8 {
        let hash = "\(door)\(index)".md5
        if hash.hasPrefix("00000") {
            let code = hash[hash.index(hash.startIndex, offsetBy: 5)]
            password += String(code)
            print("Found next. Current password is '\(password)'. Index: \(index)")
        }
        index += 1
    }

    return password
}

//let password = findPassword(for: "uqwqemis")
//print("Password:", password)

// MARK: Part 2

func findPassword2(for door: String) -> String {
    var password = Array(repeating: "_", count: 8)
    var index = 4515050
    var countFound = 0

    print(password.joined())

    while countFound < 8 {
        let hash = "\(door)\(index)".md5
        if hash.hasPrefix("00000") {
            if let position = Int(String(hash[hash.index(hash.startIndex, offsetBy: 5)])), position < 8 {
                if password[position] == "_" {
                    let code = String(hash[hash.index(hash.startIndex, offsetBy: 6)])
                    password[position] = code
                    countFound += 1
                    print("\(password.joined()) @ \(index)")
                }
            }
        }
        index += 1
    }

    return password.joined()
}

let password = findPassword2(for: "uqwqemis")
