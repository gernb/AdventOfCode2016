//
//  main.swift
//  Day 10
//
//  Created by Peter Bohac on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

final class Output {
    var bins: [String: Int] = [:]

    func add(value: Int, to bin: String) {
        bins[bin] = value
    }
}

final class Bot {
    enum Destination {
        case output(String)
        case bot(String)
    }

    let id: String
    var value1: Int?
    var value2: Int?
    var lowValueTo: Destination?
    var highValueTo: Destination?

    var has2Values: Bool {
        return value1 != nil && value2 != nil
    }

    init(id: String) {
        self.id = id
    }

    func receive(value: Int) {
        if value1 == nil {
            assert(value2 == nil)
            value1 = value
        } else {
            assert(value2 == nil)
            value2 = value
        }
    }

    func execute(output: Output, bots: [String: Bot]) {
        guard let value1 = value1, let value2 = value2,
            let lowValueTo = lowValueTo, let highValueTo = highValueTo else {
            preconditionFailure()
        }

        let lower = min(value1, value2)
        let higher = max(value1, value2)

        switch lowValueTo {
        case .bot(let botId):
            bots[botId]!.receive(value: lower)
        case .output(let binId):
            output.add(value: lower, to: binId)
        }

        switch highValueTo {
        case .bot(let botId):
            bots[botId]!.receive(value: higher)
        case .output(let binId):
            output.add(value: higher, to: binId)
        }

        self.value1 = nil
        self.value2 = nil
    }
}

extension Bot {
    static func load(from input: String) -> [String: Bot] {
        var bots: [String: Bot] = [:]

        input.split(separator: "\n").forEach { line in
            let words = line.split(separator: " ")
            if words[0] == "value" {
                let value = Int(String(words[1]))!
                let botId = String(words.last!)
                let bot = bots[botId] ?? Bot(id: botId)
                bot.receive(value: value)
                bots[botId] = bot
            } else {
                let botId = String(words[1])
                let bot = bots[botId] ?? Bot(id: botId)

                let destinationLow = words[5]
                let destinationLowId = String(words[6])
                switch destinationLow {
                case "bot":
                    bot.lowValueTo = .bot(destinationLowId)
                case "output":
                    bot.lowValueTo = .output(destinationLowId)
                default:
                    preconditionFailure()
                }

                let destinationHigh = words[10]
                let destinationHighId = String(words[11])
                switch destinationHigh {
                case "bot":
                    bot.highValueTo = .bot(destinationHighId)
                case "output":
                    bot.highValueTo = .output(destinationHighId)
                default:
                    preconditionFailure()
                }

                bots[botId] = bot
            }
        }

        return bots
    }
}

let output = Output()
var bots = Bot.load(from: InputData.challenge)

while let bot = bots.first(where: { $0.value.has2Values })?.value {
    if (bot.value1 == 61 || bot.value1 == 17) && (bot.value2 == 61 || bot.value2 == 17) {
        print("Bot \(bot.id) is comparing 61 and 17")
    }
    bot.execute(output: output, bots: bots)
}

let bin0 = output.bins["0"]!
let bin1 = output.bins["1"]!
let bin2 = output.bins["2"]!

print("Result:", bin0 * bin1 * bin2)
