//
//  Utils.swift
//  Swift6502
//
//  Created by Antonio Malara on 14/10/15.
//  Copyright © 2015 Antonio Malara. All rights reserved.
//

extension CpuState {
    func description() -> String {
        return String(
            format:" PC  SP SR AC XR YR\n%04X %02X %02X %02X %02X %02X ",
            PC,
            SP,
            A,
            X,
            Y,
            SR.rawValue
        )
    }
}