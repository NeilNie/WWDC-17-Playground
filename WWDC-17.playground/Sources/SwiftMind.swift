//
//  SwiftMind.swift
//  
//
//  Created by Yongyang Nie on 3/11/17.
//
//

import Foundation
import UIKit
import Accelerate

public enum SwiftMindError: Error {
    case InvalidInputsError(String)
    case InvalidAnswerError(String)
    case InvalidWeightsError(String)
}

public final class SwiftMind {
    
    var learningRate: Float
    var momentum: Float
    var dimension: [Int]
    
    private var weights: [[Float]]
    private var results: Array<[Float]>
    private var costs: Array<[Float]>
    
    public init(dimension: [Int], learningRate: Float, momentum: Float, weights: [[Float]]? = nil) {
        
        print("begin init")
        
        self.dimension = [Int](repeating: 0, count: dimension.count);
        self.weights = [[Float]]()
        self.costs = Array.init()
        self.results = Array.init()
        
        self.dimension = dimension
        self.learningRate = learningRate
        self.momentum = momentum
        
        for index in 0..<dimension.count-1{
            //add bias node to everything but final layer
            self.dimension[index] = dimension[index] + 1
            //get random weights
            if (weights != nil) {
                self.weights = weights!
            }else{
                print("try to generate weights")
                self.weights[index] = self.randWeights(count: dimension[index] * dimension[index + 1])
            }
        }
        print("mind created")
    }
    
    public init(){
        learningRate = 0.00
        momentum = 0.00
        dimension = [0, 0, 0]
        weights = [[Float]]()
        results = Array<[Float]>()
        costs = Array<[Float]>()
    }
    
    public func predict(inputs: [Float]) {
        
        self.results[0] = inputs;
        for i in 1..<self.dimension.count{
            do{
                try self.results[i] = self.forwardFeed(layerIndex: i, inputs: self.results[i-1], weights: self.weights[i])
            }catch{
                print("Failed to forward feed")
            }
        }
    }
    
    public func forwardFeed(layerIndex: Int, inputs: [Float], weights: [Float]) throws -> [Float] {
        
        guard inputs.count == self.dimension[layerIndex] else {
            throw SwiftMindError.InvalidAnswerError("Invalid number of outputs given in answer. Expected: \(self.dimension[layerIndex])")
        }
        
        var output = [Float](repeating: 0, count: inputs.count)
        output[0] = 1.0
        for i in 1..<inputs.count-1 {
            output[i] = inputs[i - 1]
        }
        
        vDSP_mmul(weights, 1,
                  inputs, 1,
                  &output, 1,
                  vDSP_Length(self.dimension[layerIndex + 1]), vDSP_Length(1), vDSP_Length(self.dimension[layerIndex]))
        
        output = self.applyActivation(result: output);
        
        return output;
    }
    
    public func backProp(target: [Float]){
        
    }
    
    // MARK: Private helpers
    
    private func applyActivation(result: [Float]) -> [Float]{
        
        var output = [Float](repeating: 0, count: result.count)
        for (index, value) in result.enumerated(){
            output[index] = NNMath.sigmoid(x: value);
        }
        return result;
    }
    
    private func randWeights(count: Int) -> [Float]{
        var weights = [Float](repeating: 0.00, count: count)
        for index in 0..<count{
            
            let range = 1 / sqrt(Double(count))
            let rangeInt = UInt32(2_000_000 * range)
            let weight = Float(arc4random_uniform(rangeInt)) - Float(rangeInt / 2)
            
            weights[index] = weight / 1_000_000
        }
        return weights;
    }
}

