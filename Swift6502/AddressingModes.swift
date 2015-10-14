//
//  AddressingModes.swift
//  Swift6502
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

let AddressingModeImplied = AddressingMode(
    name: "AddressingModeImplied",
    instructionSize: 1,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeImmediate = AddressingMode(
    name: "AddressingModeImmediate",
    instructionSize: 2,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeZeroPage = AddressingMode(
    name: "AddressingModeZeroPage",
    instructionSize: 2,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeAccumulator = AddressingMode(
    name: "AddressingModeAccumulator",
    instructionSize: 1,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeAbsolute = AddressingMode(
    name: "AddressingModeAbsolute",
    instructionSize: 3,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeZeroPageX = AddressingMode(
    name: "AddressingModeZeroPageX",
    instructionSize: 2,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeZeroPageY = AddressingMode(
    name: "AddressingModeZeroPageY",
    instructionSize: 2,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeAbsoluteX = AddressingMode(
    name: "AddressingModeAbsoluteX",
    instructionSize: 3,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeAbsoluteY = AddressingMode(
    name: "AddressingModeAbsoluteY",
    instructionSize: 3,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeIndexedX = AddressingMode(
    name: "AddressingModeIndexedX",
    instructionSize: 2,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeIndexedY = AddressingMode(
    name: "AddressingModeIndexedY",
    instructionSize: 2,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeIndirect = AddressingMode(
    name: "AddressingModeIndirect",
    instructionSize: 3,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

let AddressingModeRelative = AddressingMode(
    name: "AddressingModeRelative",
    instructionSize: 2,
    resolve: {
        (cpuState: CpuState, memory: Memory) in
        
        return 0
    }
)

