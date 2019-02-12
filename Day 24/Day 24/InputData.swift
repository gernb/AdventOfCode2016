//
//  InputData.swift
//  Day 24
//
//  Created by Bohac, Peter on 2/11/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

struct InputData {
    static let example = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
""".split(separator: "\n").map(Array.init)

    static let challenge = """
#######################################################################################################################################################################################
#.......#.....#.....#.#.....#.#...#.#.......#.....#.#...#.......#...........#...#.............#.....#.......#.........#.....#.....#...........#.#...................#.....#...........#
#.#######.#.#.#.###.#.#####.#.#.#.#.#####.#.#.###.#.#######.#.###.#.#.#.#.#####.#.#########.#.###.#.#.#.#.#.#.#.#.###.#.#####.#.#.#.#.#.#.#.#.#.#.#.###.#####.#.#.#.#.#.#.#.#.#.#.#.#.#
#....0#.#.....#.#...#.......#.......#...#...#.#......1#.....#.....#.........#...#...#.....#.........#.#...#.#.#.#.#...#.#...#.....#...#...#...#.#...#.#.#.#...........#.#.......#.#..3#
#.#####.#.#.#.#.#.###.###.#.###.#.#.#.###.#.#.#.#.#.#.###.#.#.#######.#.#.#.###.#.#.#.#.#######.#.###.###.#.#.###.#####.#.#.#.#####.###.#.#.#########.#.#.#.###.#####.#.#.#####.#.#.###
#...#...#.#.#.....#...#.............#.#.......#.......#.#...#.#.........#.......#.#.....#.......#.......................#.#...#.#.#...#...#.#.#...#...#.......#.........#...#.#.....#.#
#.#.###.#.#.#.#.#.#.#.#.#.###.#.#.#.#.#.###.###.###.#.#.#.#.###.###.###.#.#.#####.#.#.#.#.#.#.#.#.###.#.###########.#.#.#.#.#.#.#.###.###.#.#.#.#.#.#.#.#.#.#.#####.###.#.###.#.#####.#
#...#...#...#...#.#.#.#...#...#...#...#.....#...................#...#.#.....#...........#.....#.#.#...#.#...#.........#.#.......#...........#...#.....#...#.#...............#.#.......#
#.#.#.#.###.#.#.###.#######.#.#.#.#.#.#.###.#.###.#.#.#.###.#.#.#.#.#.#.#####.#.#.###.#.#.###.#.#.#.#.#.###.###.#.#.#.#####.#.###########.#.#.#.#########.#.#.###.###.###.#.#.###.#.#.#
#.#.........#...#.....#.....#.#...#...#.....#...............#...#.......#.#.#.......#.#...#.....#.#.#.........#.#.........#...#...#.........#.#...#.#.#...........#.....#.......#.....#
#.#.#.#.#.###.#.#.#.#.#.#.###.#########.#.#.###.#.#.#####.#####.#.#####.#.#.###.#.#.#.#.#.#.#.#.#.#.#.#.#.###.###.###.#.#.###.###.#.#.#.#.#.###.#.#.#.#.#.#####.###.#.#.#######.#.###.#
#...#.........#...#.#...#.#.#...........#.#.#...........#.......#.#.#.....#...#.#.#.#...#.......#.........#...#.....#...#.....#.#.....#.#...#.....#.#...#.....#.#.#.#.............#...#
#.#.###########.###.#.###.#.#####.#.#.#.###.#.###.#.#.#.#########.#.#.#####.#.#.#.#.#.#.#####.#.#.#.###.#.#.#.#.###############.#.###.#.#.#.#.#.###.###.#.#.#.#.#.#.#####.#.#.###.#.###
#.....#.#...........#.#.............#.#...........#.....#.#.....#...#.#.#.#...........#.#.....#...#.....#...#.....#...........#.#.#...#.........#.#.....#...#.......#.....#...#.......#
#####.#.#.#.#.#.#####.#.#####.#.#.#.#.###.#.#.###.#######.#.#.#####.#.#.#.#.#.#####.###.#.###.#.#.#.#####.#.#.###.#.###.#.###.#.#.###.#.###.###.#.#.#.#.###.#.#####.#.#.#.#####.#.###.#
#.....#.#.....#.#.......#.......#.....#...#...#...............#.....#...........#.........#.....#.#.#.............#.#...#.#.....#.#...#...#...#.........#.....#...#...#...........#...#
#.#.#.###.#.###.#.#.#.###.#.###.#.#.#.###.###.#.###.#.#.#.#####.#.#.#.###.#####.#####.#.#.#.###.#.###.###.#####.#.#.#.#.#.###.###.#.###.#.#.#.#.#.#####.#####.#.#.#.###.#.#.#.#####.###
#...#.....#.#.......#.....#.#.....#...#...#.#.#.....#...#.#...#.#.....................#.....#.....#.....#.......#.........#...#...#...#.#.#.#...#.#.#...#...#.....#.#.......#...#.....#
#####.###.###.#.#.#.#.#.#.###.#.#.#.#####.#.#.#.#.#.#######.#.#.#.#.#.#######.###.#.###.#.#.###.#.#.#.#.#.#####.#.#.#.###.#.###.###.#.###.#.###.#.#.#.#.###.#.###.###.#####.###.#.#####
#.....#.....#...#.....#.#...#...#.........#...................#.....#...#.........#.....#...........#...#.#.......#.#...#...#...............#.......#...#.........#.............#.....#
#.#.#.#.#######.#.#.#########.#######.###.#####.###.#.###.#.#######.#.###.#.###.###.###.#####.#####.###.#.#.#.#.#.#.#.###.#.#.#######.#.#.#.#.#.#.#.#.#####.#.#.#.#.#.#.###.#.#.###.#.#
#2#.#.......#...#.#...#.......#.................#.....#...#.......#.#.....#.....#.#...#.#.....#...#.#.......#...#.....#.....#.....#.......#.....#...#.#...#.....#...#.#.#7..#...#.....#
###.#.#####.#.###.###.#.#.###.#.###.#####.#.#.#######.#.#########.#####.#.#.#.###.#.#.#.###.#######.#.#########.#.#.#.#.#.#.#####.###.###.###.#.#.#.#.#.#.#.###.#.#.#.#.#####.#.#.###.#
#.#...#.....#.....#.#.....#...#...#.#...#...#.#.#.#.....#.....#.#.#.#.....#.................#.#.#...#...#...#.#.#.#.#.#...#...#.#.............#.#...#...#.#.#.......#.........#.#.....#
#.###.#.###.#.#.#.#.###.#.#.###.#####.#.###.#.#.#.#.#.###.#.#.#.#.#.#.#.#.#.#.#####.###.#.###.#.#.###.#.#.#.#.#.#.#.#.#.###.#.#.###.#.#.#.#######.#.###.#.#.#.###.#.#.#.###.###.#.#.#.#
#.#...#.....#.....#.#...#...#.......#...#.....#.#.#.....#.#...#...#...#.#.........#.....#...#.#...#...#...#.#.#.......#...#.#...#...#.#...#.....#.......#.......#.#.....#.#...#.#.....#
#.#.#.#.#.#.#.###.#.###.#.#.#.###.###.#.#.###.###.#.#.#.#.###.#.#.#.#.#.#.#########.#.#.#.#.#.#######.#.###.#.#.#.#.#.#.###.#.###.#######.#.#.#.#.###.#.#.#.#.#.#.#.#####.###.#.#.###.#
#.....#.....#.#...#.#.#...#.....#.....#.#...#.....#.....#.....#.#.#...#...#.#.....#.#.#...#...#.......#.....#...........#...#.#...#.......#.......#.#.#...#.#...#.#.#...........#.....#
#.#####.#####.#####.#.###.#########.#.#.#.#.###.#.#.#.#.#.#.#.#####.###.#.#.#.###.#.###.#.#####.###.#####.#####.#.###.###.#.#.#.#.#.###.#.#.#####.#.#.###.###.###.#.#.#.#.#.###.###.#.#
#.....#...#...#.#...#.........#.................#.#.....#.#.....#.........#...#.....#...#.#.....#.......#.......#.....#.#.#.......#.#...#.#...#.#.........#.........#...#.....#.....#.#
#.###.#####.#.#.#.#.#.#######.#.#####.#########.#.#.###.#.#####.#.#####.###.#.#.#.#.###.#.#.#.#.###.#.#####.#.###.###.#.#.#.###.#.#.#.#.#.#.#.#.#.#####.#.#.###.#.#.#.#.#.#.#.###.###.#
#.#...#.#.....#...#.#.#.......#.#.................#...#.....#...............#.........#...#.#.#...#.#...#...#.........#.....#...........#.#...........#.....#.#.#.#...#...#...#.#.#...#
#.#.#.#.#.###.#######.#.#.#.###.#.#.#.###.#.#.###.###.#.###.#.#####.#.#.#.#.#.###.#########.#.#.#.#.#.#.#######.###.#.#.###.#.#.###.#.###.#.#.###.#.#.#.#.#.#.#.#.#.###.#####.#.###.#.#
#.#.....#.....#.#.......#...#...#...#.#...#.....#.......#...#...#...#.#.#...#...#.....#.#...#...........#.........#...#.#...#...#...#...#...........#5#.#...#...........#.....#.#.....#
###.#.###.#####.#.#.#.#.#.###.#.#.#####.#.#.#.#.#.#.#.###.###.#.#.###.#.###.###.#####.#.#.###.#.#.###.#.#.#.###.#####.###.#####.#.#.###.#.#####.#.#.#.#####.###.###.###.#.#.#.#.#.#.###
#.........#.....#.....#...#...............#.#...#.#.#.....#.#...#...#.#...............#.......#.......#.#...#.#...........#.#.#...............#...#.........#...............#...#...#.#
#.#.#.###.#.#####.#.#.#.#.#.#.###.###.###.#####.#.#####.###.#.#.###.#.###.###.#####.#####.#####.#########.###.#.#.#.#.#.#.#.#.#.#.#.#.###.#.#.###.#####.###.#####.###.#.###.###.#.#.#.#
#.....#.#.............#...#.......#.#.............#.#...#.#...#...#.#.....#.#.#...#.#.....#...#...........#.....#.#.#...#...................#.....#.....#...............#.....#.#.....#
#.#####.#.###.#.#######.###.###.#.#.#.###.###.#.###.#.#.#.###.#.#.#.#####.#.###.###.#########.#.#####.#.#.#.#.#.#.#.#####.#########.#.#.#.#.###.###.#.#####.#.#.###.#####.#.#.###.###.#
#...#.....#4#.#.#...............#.........#.....#.......#.........#...........#...#.......#.#...#.......#.....#...#.#...#.#...#.#.....#...........#.................#...#.#.#.#...#.#.#
#.#.#.#####.#.###.###.#.#.#####.#.#####.###.#.###.#.#######.#.#.###.###.###.#.#.#.#.#.#.#.#.#.#.#.#.#######.#######.#.#.###.###.#.###.#.###.#.#.#.#.#.#######.#.#.###.#.###.#####.#.#.#
#.....#.#.....#...#...#.#.......#...#.............#...#.....#...#.#.......#.....#...#...#.#.....#.#...........#.......#.#...#...#.#...#.#.#.....#...............#...#.#.#...#...#.....#
#####.#.#.#.###.#.###.#.#####.#######.#############.#.#.#.#.#.###.#.#.###.#.#####.#.#.#.#####.#.#.###.###.#.#.#.###.#.#.###.#.#.#.#.#.#.#.#.#.###.###.#.#######.###.#.#####.#######.###
#.....#...........#.....#.....#.......#...#...#.......#.....#.#...#.#.#...#.#...#.....#.......#...#...#...#.#.#.#.....#.....#...#.#...#......6#...#...#.....#...#...#.........#.#.....#
#######################################################################################################################################################################################
""".split(separator: "\n").map(Array.init)
}
