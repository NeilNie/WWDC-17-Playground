//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

var mind = Mind.init(inputs: 2, hidden: 3, outputs: 2, learningRate: 0.5, momentum: 0.5, weights: nil)
try mind.update(inputs: [1, 0])

//: [Next](@next)
