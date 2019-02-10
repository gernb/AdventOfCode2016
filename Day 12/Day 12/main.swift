//
//  main.swift
//  Day 12
//
//  Created by Peter Bohac on 2/9/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Instruction {
    enum Operation: String, Equatable {
        case cpy, inc, dec, jnz
    }

    let op: Operation
    let xRegister: String?
    let yRegister: String?
    let xValue: Int?
    let yValue: Int?

    init(string: String) {
        let words = string.split(separator: " ").map(String.init)
        var xRegister: String?
        var yRegister: String?
        var xValue: Int?
        var yValue: Int?

        switch words[0] {
        case "cpy":
            self.op = .cpy
            if let value = Int(words[1]) {
                xValue = value
            } else {
                xRegister = words[1]
            }
            yRegister = words[2]

        case "inc":
            self.op = .inc
            xRegister = words[1]

        case "dec":
            self.op = .dec
            xRegister = words[1]

        case "jnz":
            self.op = .jnz
            if let value = Int(words[1]) {
                xValue = value
            } else {
                xRegister = words[1]
            }
            yValue = Int(words[2])!

        default:
            preconditionFailure()
        }

        self.xRegister = xRegister
        self.yRegister = yRegister
        self.xValue = xValue
        self.yValue = yValue
    }
}

final class Program {
    let instructions: [Instruction]
    var registers: [String: Int] = [:]
    var ip = 0

    init(input: [String]) {
        self.instructions = input.map(Instruction.init)
    }

    func run(registerC: Int = 0) {
        registers = ["a": 0, "b": 0, "c": registerC, "d": 0]
        ip = 0

        while ip >= 0 && ip < instructions.count {
            executeInstruction()
        }
    }

    private func executeInstruction() {
        let instr = instructions[ip]
        switch instr.op {
        case .cpy:
            registers[instr.yRegister!] = instr.xValue == nil ? registers[instr.xRegister!]! : instr.xValue!
            ip += 1

        case .inc:
            registers[instr.xRegister!] = registers[instr.xRegister!]! + 1
            ip += 1

        case .dec:
            registers[instr.xRegister!] = registers[instr.xRegister!]! - 1
            ip += 1

        case .jnz:
            let value = instr.xValue == nil ? registers[instr.xRegister!]! : instr.xValue!
            ip += value != 0 ? instr.yValue! : 1
        }
    }
}

let program = Program(input: InputData.challenge)
program.run(registerC: 1)

print(program.registers)
