//
//  Disassembler.swift
//  Swift6502
//
//  Created by Antonio Malara on 12/26/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

func mnemonic(inst: Instruction) -> String {
    switch inst {
    case .ADC: return "ADC"
    case .AND: return "AND"
    case .ASL: return "ASL"
    case .BCC: return "BCC"
    case .BCS: return "BCS"
    case .BEQ: return "BEQ"
    case .BIT: return "BIT"
    case .BMI: return "BMI"
    case .BNE: return "BNE"
    case .BPL: return "BPL"
    case .BRK: return "BRK"
    case .BVC: return "BVC"
    case .BVS: return "BVS"
    case .CLC: return "CLC"
    case .CLD: return "CLD"
    case .CLI: return "CLI"
    case .CLV: return "CLV"
    case .CMP: return "CMP"
    case .CPX: return "CPX"
    case .CPY: return "CPY"
    case .DEC: return "DEC"
    case .DEX: return "DEX"
    case .DEY: return "DEY"
    case .EOR: return "EOR"
    case .INC: return "INC"
    case .INX: return "INX"
    case .INY: return "INY"
    case .JMP: return "JMP"
    case .JSR: return "JSR"
    case .LDA: return "LDA"
    case .LDX: return "LDX"
    case .LDY: return "LDY"
    case .LSR: return "LSR"
    case .NOP: return "NOP"
    case .ORA: return "ORA"
    case .PHA: return "PHA"
    case .PHP: return "PHP"
    case .PLA: return "PLA"
    case .PLP: return "PLP"
    case .ROL: return "ROL"
    case .ROR: return "ROR"
    case .RTI: return "RTI"
    case .RTS: return "RTS"
    case .SBC: return "SBC"
    case .SEC: return "SEC"
    case .SED: return "SED"
    case .SEI: return "SEI"
    case .STA: return "STA"
    case .STX: return "STX"
    case .STY: return "STY"
    case .TAX: return "TAX"
    case .TAY: return "TAY"
    case .TSX: return "TSX"
    case .TXA: return "TXA"
    case .TXS: return "TXS"
    case .TYA: return "TYA"
        
    case .ill: return "???"
    }
}

func addressingModeFormatString(mode: AddressingMode) -> String {
    switch mode {
    case .Implied:     return ""
    case .Immediate:   return "#$%02X"
    case .ZeroPage:    return "$%02X"
    case .Accumulator: return "A"
    case .Absolute:    return "$%04X"
    case .ZeroPageX:   return "$%02X, X"
    case .ZeroPageY:   return "$%04X, Y"
    case .AbsoluteX:   return "$%04X, X"
    case .AbsoluteY:   return "$%04X, Y"
    case .IndexedX:    return "($%04X, X)"
    case .IndexedY:    return "($%04X), Y"
    case .Indirect:    return "($%04X)"
    case .Relative:    return "$%04X"
    }
}

func disassemble(addr: Address, mem: Memory) -> String {
    let opcode    = Opcodes[Int(mem.byteAt(addr))]
    let instrSize = instructionSize(opcode.1)
    let operand1  = instrSize > 1 ? mem.byteAt(addr &+ 1) : 0
    let operand2  = instrSize > 2 ? mem.byteAt(addr &+ 2) : 0
    let operand   = (UInt16(operand2) << 8) + UInt16(operand1)
    let mnemo     = mnemonic(opcode.0)
    let address   = String(format: "%04x", arguments: [addr])
    let operands  = String(format: addressingModeFormatString(opcode.1),
                           arguments: [operand])
    
    return "\(address) \(mnemo) \(operands)"
}