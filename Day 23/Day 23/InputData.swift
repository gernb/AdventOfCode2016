//
//  InputData.swift
//  Day 23
//
//  Created by Bohac, Peter on 2/11/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct InputData {
    static let example = """
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
""".split(separator: "\n").map(String.init)

    static let challenge = """
cpy a b
dec b
cpy a d
cpy 0 a
cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5
dec b
cpy b c
cpy c d
dec d
inc c
jnz d -2
tgl c
cpy -16 c
jnz 1 c
cpy 73 c
jnz 80 d
inc a
inc d
jnz d -2
inc c
jnz c -5
""".split(separator: "\n").map(String.init)
}
