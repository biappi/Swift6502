//
//  AddressingModes.swift
//  Swift6502
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//


extension Memory {
    func wordAtPageWrapping(address: UInt16) -> UInt16 {
        let wrappedHi  = (address & 0xff00    )
        let wrappedLow = (address & 0x00ff + 1) & 0x00ff
        let wrappedInc = wrappedHi + wrappedLow
        
        let low = UInt16(byteAt(UInt16(address)))
        let hi  = UInt16(byteAt(UInt16(wrappedInc)))
        
        return hi << 8 + low
    }
}

let AddressingModeImplied = AddressingMode(
    name: "AddressingModeImplied",
    instructionSize: 1,
    resolve: { _ in return .Implied }
)

let AddressingModeImmediate = AddressingMode(
    name: "AddressingModeImmediate",
    instructionSize: 2,
    resolve: { (cpu, mem) in return .Address(cpu.PC + 1) }
)

let AddressingModeZeroPage = AddressingMode(
    name: "AddressingModeZeroPage",
    instructionSize: 2,
    resolve: { (cpu, mem) in return .Address(UInt16(mem.byteAt(cpu.PC + 1))) }
)

let AddressingModeAccumulator = AddressingMode(
    name: "AddressingModeAccumulator",
    instructionSize: 1,
    resolve: { (cpu, _) in return .Accumulator(cpu.A) }
)

let AddressingModeAbsolute = AddressingMode(
    name: "AddressingModeAbsolute",
    instructionSize: 3,
    resolve: { (cpu, mem) in return .Address(mem.wordAt(cpu.PC + 1)) }
)

let AddressingModeZeroPageX = AddressingMode(
    name: "AddressingModeZeroPageX",
    instructionSize: 2,
    resolve: { (cpu, mem) in return .Address(UInt16(mem.byteAt(cpu.PC + 1) &+ cpu.X)) }
)

let AddressingModeZeroPageY = AddressingMode(
    name: "AddressingModeZeroPageY",
    instructionSize: 2,
    resolve: { (cpu, mem) in return .Address(UInt16(mem.byteAt(cpu.PC + 1) &+ cpu.Y)) }
)

let AddressingModeAbsoluteX = AddressingMode(
    name: "AddressingModeAbsoluteX",
    instructionSize: 3,
    resolve: { (cpu, mem) in return .Address(mem.wordAt(cpu.PC + 1) + cpu.X16) }
)

let AddressingModeAbsoluteY = AddressingMode(
    name: "AddressingModeAbsoluteY",
    instructionSize: 3,
    resolve: { (cpu, mem) in return .Address(mem.wordAt(cpu.PC + 1) + cpu.Y16) }
)

let AddressingModeIndexedX = AddressingMode(
    name: "AddressingModeIndexedX",
    instructionSize: 2,
    resolve: {
        (cpu, mem) in
        let value   = mem.byteAt(cpu.PC + 1)
        let address = mem.wordAtPageWrapping(UInt16(value &+ cpu.X))
        return .Address(address)
    }
)

let AddressingModeIndexedY = AddressingMode(
    name: "AddressingModeIndexedY",
    instructionSize: 2,
    resolve: {
        (cpu, mem) in
        let value   = UInt16(mem.byteAt(cpu.PC + 1))
        let address = mem.wordAtPageWrapping(value) + cpu.Y16
        return .Address(address)
    }
)

let AddressingModeIndirect = AddressingMode(
    name: "AddressingModeIndirect",
    instructionSize: 3,
    resolve: { (cpu, mem) in return .Address(mem.wordAtPageWrapping(mem.wordAt(cpu.PC + 1))) }
)

let AddressingModeRelative = AddressingMode(
    name: "AddressingModeRelative",
    instructionSize: 2,
    resolve: {
        (cpu, mem) in
        let offset = Int(Int8(bitPattern:mem.byteAt(cpu.PC + 1)))
        let address = Int(cpu.PC) + offset + 2
        return .Address(UInt16(truncatingBitPattern:address))
    }
)
