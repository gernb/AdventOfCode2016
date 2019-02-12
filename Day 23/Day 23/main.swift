//
//  main.swift
//  Day 23
//
//  Created by Peter Bohac on 2/11/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct Instruction {
    enum Operation: String, Equatable {
        case cpy, inc, dec, jnz, tgl
    }

    var op: Operation
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
            if let value = Int(words[2]) {
                yValue = value
            } else {
                yRegister = words[2]
            }

        case "tgl":
            self.op = .tgl
            if let value = Int(words[1]) {
                xValue = value
            } else {
                xRegister = words[1]
            }

        default:
            preconditionFailure()
        }

        self.xRegister = xRegister
        self.yRegister = yRegister
        self.xValue = xValue
        self.yValue = yValue
    }

    mutating func toggle() {
        switch op {
        case .inc: self.op = .dec
        case .dec, .tgl: self.op = .inc
        case .jnz: self.op = .cpy
        case .cpy: self.op = .jnz
        }
    }
}

final class Program {
    var instructions: [Instruction]
    var registers: [String: Int] = [:]
    var ip = 0

    init(input: [String]) {
        self.instructions = input.map(Instruction.init)
    }

    func run(registerA: Int = 0) {
        registers = ["a": registerA, "b": 0, "c": 0, "d": 0]
        ip = 0

        while ip >= 0 && ip < instructions.count {
            executeInstruction()
        }
    }

    private func executeInstruction() {
        let instr = instructions[ip]
        switch instr.op {
        case .cpy:
            if let yReg = instr.yRegister {
                registers[yReg] = instr.xValue == nil ? registers[instr.xRegister!]! : instr.xValue!
            }
            ip += 1

        case .inc:
            if let xReg = instr.xRegister {
                registers[xReg] = registers[instr.xRegister!]! + 1
            }
            ip += 1

        case .dec:
            if let xReg = instr.xRegister {
                registers[xReg] = registers[instr.xRegister!]! - 1
            }
            ip += 1

        case .jnz:
            let value = instr.xValue == nil ? registers[instr.xRegister!]! : instr.xValue!
            let offset = instr.yValue == nil ? registers[instr.yRegister!]! : instr.yValue!
            ip += value != 0 ? offset : 1

        case .tgl:
            let offset = instr.xValue == nil ? registers[instr.xRegister!]! : instr.xValue!
            executeToggle(at: ip + offset)
            ip += 1
        }
    }

    private func executeToggle(at index: Int) {
        guard index >= 0 && index < instructions.count else { return }
        instructions[index].toggle()
    }
}

let program = Program(input: InputData.challenge)
program.run(registerA: 7) // => 7! + (73 * 80)
//program.run(registerA: 12) // => 12! + (73 * 80)

print(program.registers)
