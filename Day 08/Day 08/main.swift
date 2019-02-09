//
//  main.swift
//  Day 08
//
//  Created by Bohac, Peter on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

enum Operation {
    case rect(width: Int, height: Int)
    case rotateRow(row: Int, count: Int)
    case rotateColumn(column: Int, count: Int)

    init(string: Substring) {
        let words = string.split(separator: " ")
        if words[0] == "rect" {
            let values = words[1].split(separator: "x").map { Int(String($0))! }
            self = .rect(width: values[0], height: values[1])
        } else if words[1] == "row" {
            let row = Int(String(words[2].dropFirst(2)))!
            let count = Int(String(words.last!))!
            self = .rotateRow(row: row, count: count)
        } else if words[1] == "column" {
            let column = Int(String(words[2].dropFirst(2)))!
            let count = Int(String(words.last!))!
            self = .rotateColumn(column: column, count: count)
        } else {
            preconditionFailure()
        }
    }
}

struct Display {
    var pixels: [[Int]]

    var litPixelsCount: Int {
        return pixels.flatMap { $0 }.reduce(0, +)
    }

    init(width: Int, height: Int) {
        pixels = Array(repeating: Array(repeating: 0, count: width), count: height)
    }

    mutating func execute(instructions: [Operation]) {
        instructions.forEach { perform(operation: $0) }
    }

    mutating func perform(operation: Operation) {
        switch operation {

        case .rect(let width, let height):
            for y in 0 ..< height {
                for x in 0 ..< width {
                    pixels[y][x] = 1
                }
            }

        case .rotateRow(let row, let count):
            let pixelRow = pixels[row]
            assert(count <= pixelRow.count)
            let head = pixelRow.suffix(count)
            let tail = pixelRow.dropLast(count)
            pixels[row] = Array(head + tail)

        case .rotateColumn(let column, let count):
            let pixelColumn = (0 ..< pixels.count).map { pixels[$0][column] }
            assert(count <= pixelColumn.count)
            let head = pixelColumn.suffix(count)
            let tail = pixelColumn.dropLast(count)
            let newColumn = Array(head + tail)
            (0 ..< pixels.count).forEach { pixels[$0][column] = newColumn[$0] }
        }
    }
}

let instructions = InputData.challenge.split(separator: "\n").map(Operation.init)
print("Count:", instructions.count)

var display = Display(width: 50, height: 6)
display.execute(instructions: instructions)
print("Lit pixels count:", display.litPixelsCount)

// MARK: Part 2

extension Display {
    func draw() {
        for (_, line) in pixels.enumerated() {
            for (_, pixel) in line.enumerated() {
                print(pixel == 1 ? "#" : " ", terminator: "")
            }
            print("")
        }
    }
}

display.draw()
