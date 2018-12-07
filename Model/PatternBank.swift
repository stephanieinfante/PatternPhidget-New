//
//  PatternBank.swift
//  PatternPhidget
//


import Foundation

class PatternBank {
    
    var list = [Pattern]()
    
    init() {
    
        list.append(Pattern(patternForPlayer: "Green-Green-Red-Green", playerAns1: true, playerAns2: true, playerAns3: false, playerAns4: true))
        list.append(Pattern(patternForPlayer: "Red-Green-Red-Green", playerAns1: false, playerAns2: true, playerAns3: false, playerAns4: true))
        list.append(Pattern(patternForPlayer: "Green-Red-Red-Red", playerAns1: true, playerAns2: false, playerAns3: false, playerAns4: false))
        list.append(Pattern(patternForPlayer: "Red-Red-Red-Red", playerAns1: false, playerAns2: false, playerAns3: false, playerAns4: false))
    }
    
}

