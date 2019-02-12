//
//  InputData.swift
//  Day 25
//
//  Created by Peter Bohac on 2/11/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct InputData {
    static let challenge = """
cpy a d
cpy 4 c
cpy 633 b
inc d
dec b
jnz b -2
dec c
jnz c -5
cpy d a
jnz 0 0
cpy a b
cpy 0 a
cpy 2 c
jnz b 2
jnz 1 6
dec b
dec c
jnz c -4
inc a
jnz 1 -7
cpy 2 b
jnz c 2
jnz 1 4
dec b
dec c
jnz 1 -4
jnz 0 0
out b
jnz a -19
jnz 1 -21
""".split(separator: "\n").map(String.init)
}
