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

func instructionSize(mode: AddressingMode) -> Int {
    switch mode {
    case .Implied:     return 1
    case .Immediate:   return 2
    case .ZeroPage:    return 2
    case .Accumulator: return 1
    case .Absolute:    return 3
    case .ZeroPageX:   return 2
    case .ZeroPageY:   return 2
    case .AbsoluteX:   return 3
    case .AbsoluteY:   return 3
    case .IndexedX:    return 2
    case .IndexedY:    return 2
    case .Indirect:    return 3
    case .Relative:    return 2
    }
}

func resolveOpcodeValue(
    mode: AddressingMode,
    cpu:  CpuState,
    mem:  Memory
) -> OpcodeValue
{
    switch mode {
    case .Implied:     return .Implied
    case .Immediate:   return .Address(cpu.PC + 1)
    case .ZeroPage:    return .Address(UInt16(mem.byteAt(cpu.PC + 1)))
    case .Accumulator: return .Accumulator(cpu.A)
    case .Absolute:    return .Address(mem.wordAt(cpu.PC + 1))
    case .ZeroPageX:   return .Address(UInt16(mem.byteAt(cpu.PC + 1) &+ cpu.X))
    case .ZeroPageY:   return .Address(UInt16(mem.byteAt(cpu.PC + 1) &+ cpu.Y))
    case .AbsoluteX:   return .Address(mem.wordAt(cpu.PC + 1) + cpu.X16)
    case .AbsoluteY:   return .Address(mem.wordAt(cpu.PC + 1) + cpu.Y16)
        
    case .IndexedX:
        let value   = mem.byteAt(cpu.PC + 1)
        let address = mem.wordAtPageWrapping(UInt16(value &+ cpu.X))
        return .Address(address)
        
    case .IndexedY:
        let value   = UInt16(mem.byteAt(cpu.PC + 1))
        let address = mem.wordAtPageWrapping(value) + cpu.Y16
        return .Address(address)
        
    case .Indirect:
        return .Address(mem.wordAtPageWrapping(mem.wordAt(cpu.PC + 1)))
        
    case .Relative:
        let offset = Int(Int8(bitPattern:mem.byteAt(cpu.PC + 1)))
        let address = Int(cpu.PC) + offset + 2
        return .Address(UInt16(truncatingBitPattern:address))
    }
}
