//
//  main.swift
//  Day 11
//
//  Created by Peter Bohac on 2/8/19.
//  Copyright © 2019 Peter Bohac. All rights reserved.
//

import Foundation

struct State: Hashable {
    let elevator: Int
    let chips: [Int]
    let generators: [Int]

    // example
//    static let initial = State(elevator: 1, chips: [1, 1], generators: [2, 3])
//    static let target = State(elevator: 4, chips: [4, 4], generators: [4, 4])
    // challenge
    static let initial = State(elevator: 1, chips: [1, 3, 3, 3, 3], generators: [1, 2, 2, 2, 2])
    static let target = State(elevator: 4, chips: [4, 4, 4, 4, 4], generators: [4, 4, 4, 4, 4])
    // challenge, part 2
//    static let initial = State(elevator: 1, chips: [1, 3, 3, 3, 3, 1, 1], generators: [1, 2, 2, 2, 2, 1, 1])
//    static let target = State(elevator: 4, chips: [4, 4, 4, 4, 4, 4, 4], generators: [4, 4, 4, 4, 4, 4, 4])

    var nextStates: [State] {
        return getNextStates()
    }

    var isLegal: Bool {
        for floor in 1 ... 4 {
            let floorRTGs = getGenerators(onFloor: floor)
            let floorChips = getChips(onFloor: floor)
            for (_, chip) in floorChips.enumerated() {
                if floorRTGs.contains(chip) {
                    continue // chip and same RTG are together
                }
                if floorRTGs.isEmpty == false {
                    return false // floor contains an unpowered chip and an RTG
                }
            }
        }
        return true
    }

    private func getGenerators(onFloor floor: Int) -> [Int] {
        var result: [Int] = []
        for (i, currentFloor) in generators.enumerated() {
            if floor == currentFloor {
                result.append(i)
            }
        }
        return result
    }

    private func getChips(onFloor floor: Int) -> [Int] {
        var result: [Int] = []
        for (i, currentFloor) in chips.enumerated() {
            if floor == currentFloor {
                result.append(i)
            }
        }
        return result
    }

    private func getNextStates() -> [State] {
        let directions: [Int] = {
            switch elevator {
            case 1: return [1]
            case 2: return [1, -1]
            case 3: return [1, -1]
            case 4: return [-1]
            default: preconditionFailure()
            }
        }()
        let floorRTGs = getGenerators(onFloor: elevator)
        let floorChips = getChips(onFloor: elevator)
        return directions.flatMap { direction -> [State] in
            let newFloor = elevator + direction
//            return make2ItemMoves(to: newFloor, chipsOnFloor: floorChips, rtgsOnFloor: floorRTGs) +
//                make1ItemMoves(to: newFloor, chipsOnFloor: floorChips, rtgsOnFloor: floorRTGs)
            if direction == 1 {
                // going up
                let twoItemMoves = make2ItemMoves(to: newFloor, chipsOnFloor: floorChips, rtgsOnFloor: floorRTGs)
                if twoItemMoves.isEmpty {
                    let oneItemMoves = make1ItemMoves(to: newFloor, chipsOnFloor: floorChips, rtgsOnFloor: floorRTGs)
                    return oneItemMoves
                } else {
                    return twoItemMoves
                }
            } else {
                // going down
                let oneItemMoves = make1ItemMoves(to: newFloor, chipsOnFloor: floorChips, rtgsOnFloor: floorRTGs)
                if oneItemMoves.isEmpty {
                    let twoItemMoves = make2ItemMoves(to: newFloor, chipsOnFloor: floorChips, rtgsOnFloor: floorRTGs)
                    return twoItemMoves
                } else {
                    return oneItemMoves
                }
            }
        }
    }

    private func make1ItemMoves(to floor: Int, chipsOnFloor: [Int], rtgsOnFloor: [Int]) -> [State] {
        var moves: [State] = []
        chipsOnFloor.forEach { chip in
            var newChips = chips
            newChips[chip] = floor
            moves.append(State(elevator: floor, chips: newChips, generators: generators))
        }
        rtgsOnFloor.forEach { rtg in
            var newRTGs = generators
            newRTGs[rtg] = floor
            moves.append(State(elevator: floor, chips: chips, generators: newRTGs))
        }
        return moves.filter { $0.isLegal }
    }

    private func make2ItemMoves(to floor: Int, chipsOnFloor: [Int], rtgsOnFloor: [Int]) -> [State] {
        var moves: [State] = []
        let pairedChipsAndRTGs = chipsOnFloor.reduce(into: [] as [Int]) { result, id in
            if rtgsOnFloor.contains(id) {
                result.append(id)
            }
        }
        pairedChipsAndRTGs.forEach { id in
            var newChips = chips
            newChips[id] = floor
            var newRTGs = generators
            newRTGs[id] = floor
            moves.append(State(elevator: floor, chips: newChips, generators: newRTGs))
        }
        if chipsOnFloor.count >= 2 {
            for i in 0 ..< (chipsOnFloor.count - 1) {
                for j in (i + 1) ..< chipsOnFloor.count {
                    var newChips = chips
                    newChips[chipsOnFloor[i]] = floor
                    newChips[chipsOnFloor[j]] = floor
                    moves.append(State(elevator: floor, chips: newChips, generators: generators))
                }
            }
        }
        if rtgsOnFloor.count >= 2 {
            for i in 0 ..< (rtgsOnFloor.count - 1) {
                for j in (i + 1) ..< rtgsOnFloor.count {
                    var newRTGs = generators
                    newRTGs[rtgsOnFloor[i]] = floor
                    newRTGs[rtgsOnFloor[j]] = floor
                    moves.append(State(elevator: floor, chips: chips, generators: newRTGs))
                }
            }
        }
        return moves.filter { $0.isLegal }
    }
}

extension State {
    func draw() {
        [4, 3, 2, 1].forEach { floor in
            var line = "F\(floor) "
            line += elevator == floor ? "E  " : ".  "
            (0 ..< chips.count).forEach { index in
                line += generators[index] == floor ? "G\(index) " : ".  "
                line += chips[index] == floor ? "M\(index) " : ".  "
            }
            print(line)
        }
    }
}

func findShortestPath(from: State, to target: State) -> Int {
    var seen: [State: Int] = [:]
    var queue: [(state: State, steps: Int)] = [(from, 0)]

    while queue.isEmpty == false {
        let (state, steps) = queue.removeFirst()
        if state == target {
            return steps
        }
        let nextStates = state.nextStates
        let nextSteps = steps + 1
        nextStates.forEach { nextState in
            if let count = seen[nextState], steps >= count {
                return
            }
            if let queuedIdx = queue.firstIndex(where: { $0.state == nextState }) {
                let queued = queue[queuedIdx]
                if nextSteps < queued.steps {
                    queue[queuedIdx] = (nextState, nextSteps)
                }
                return
            }
            queue.append((nextState, nextSteps))
        }
        seen[state] = steps
    }

    preconditionFailure()
}

let startDate = Date()
let count = findShortestPath(from: State.initial, to: State.target)
let endDate = Date()
print("Steps:", count)
print("Seconds:", endDate.timeIntervalSince(startDate))
