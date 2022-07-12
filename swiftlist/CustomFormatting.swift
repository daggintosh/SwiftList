//
//  CustomFormatting.swift
//  swiftlist
//
//  Created by Dagg on 7/11/22.
//

import Foundation

let intervals: [Int64] = [
    1,
    1000,
    1000000,
    1000000000
]

let dn = [
    "K",
    "M",
    "B"
]

extension Int64 {
    var abbreviate: String {
        let input: Int64 = self
        var output: String = ""
        let number = Int64(input)
        var potential: Double
        for (index, num) in intervals.enumerated() {
            potential = Double(number) / Double(num)
            if(potential > 1.0 && potential < 1000.0) {
                if(index == 0) {
                    output = "\(potential)"
                }
                else {
                    let formatter: NumberFormatter = NumberFormatter()
                    formatter.maximumFractionDigits = 0
                    let nout = formatter.string(from: potential as NSNumber)!
                    output = "\(nout)\(dn[index-1])"
                }
                break
            }
        }
        
        
        return output
    }

}
