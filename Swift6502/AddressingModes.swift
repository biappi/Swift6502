//
//  AddressingModes.swift
//  Swift6502
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//


extension Memory {
    func byte16At(address: Address) -> UInt16 {
        return UInt16(self.byteAt(address))
    }
}

let AddressingModeImplied = AddressingMode(
    name: "AddressingModeImplied",
    instructionSize: 1,
    resolve: { _ in return 0 }
)

let AddressingModeImmediate = AddressingMode(
    name: "AddressingModeImmediate",
    instructionSize: 2,
    resolve: { (cpu, mem) in return UInt16(mem.byteAt(cpu.PC + 1)) }
)

let AddressingModeZeroPage = AddressingMode(
    name: "AddressingModeZeroPage",
    instructionSize: 2,
    resolve: { (cpu, mem) in return mem.wordAt(UInt16(mem.byteAt(cpu.PC + 1))) }
)

let AddressingModeAccumulator = AddressingMode(
    name: "AddressingModeAccumulator",
    instructionSize: 1,
    resolve: { (cpu, _) in return cpu.A16 }
)

let AddressingModeAbsolute = AddressingMode(
    name: "AddressingModeAbsolute",
    instructionSize: 3,
    resolve: { (cpu, mem) in return mem.wordAt(cpu.PC + 1) }
)

let AddressingModeZeroPageX = AddressingMode(
    name: "AddressingModeZeroPageX",
    instructionSize: 2,
    resolve: { (cpu, mem) in return mem.byte16At(UInt16(mem.byteAt(cpu.PC + 1)) + cpu.X16) }
)

let AddressingModeZeroPageY = AddressingMode(
    name: "AddressingModeZeroPageY",
    instructionSize: 2,
    resolve: { (cpu, mem) in return mem.byte16At(UInt16(mem.byteAt(cpu.PC + 1)) + cpu.Y16) }
)

let AddressingModeAbsoluteX = AddressingMode(
    name: "AddressingModeAbsoluteX",
    instructionSize: 3,
    resolve: { (cpu, mem) in return mem.byte16At(mem.wordAt(cpu.PC + 1) + cpu.X16) }
)

let AddressingModeAbsoluteY = AddressingMode(
    name: "AddressingModeAbsoluteY",
    instructionSize: 3,
    resolve: { (cpu, mem) in return mem.byte16At(mem.wordAt(cpu.PC + 1) + cpu.Y16) }
)

let AddressingModeIndexedX = AddressingMode(
    name: "AddressingModeIndexedX",
    instructionSize: 2,
    resolve: {
        (cpu, mem) in
        let value   = mem.wordAt(cpu.PC + 1)
        let address = mem.wordAt(value + cpu.X16)
        return mem.byte16At(address)
    }
)

let AddressingModeIndexedY = AddressingMode(
    name: "AddressingModeIndexedY",
    instructionSize: 2,
    resolve: {
        (cpu, mem) in
        let value   = mem.wordAt(cpu.PC + 1)
        let address = mem.wordAt(value) + cpu.Y16
        return mem.byte16At(address)
    }
)

let AddressingModeIndirect = AddressingMode(
    name: "AddressingModeIndirect",
    instructionSize: 3,
    resolve: { (cpu, mem) in return mem.wordAt(mem.wordAt(cpu.PC + 1)) }
)

let AddressingModeRelative = AddressingMode(
    name: "AddressingModeRelative",
    instructionSize: 2,
    resolve: {
        (cpu, mem) in
        let value    = mem.byteAt(cpu.PC + 1)
        let sign     = (value &  0x80)
        let rest     = (value & ~0x80)
        let positive = sign != 0x80
        let offset   = positive ? Int(rest) : -(Int(rest ^ 0xFF) + 1)
        let address  = UInt16(Int(cpu.PC + 2) + offset)
        return address
    }
)
